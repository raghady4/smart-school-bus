<?php
namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\NFCDetail;
use App\Models\NfcLog;
use Illuminate\Http\Request;
use Kreait\Firebase\Factory;
use Kreait\Firebase\Messaging\CloudMessage;
use Kreait\Firebase\Messaging\Notification as FcmNotification;

class NFCDetailController extends Controller
{
    public function index()
    {
        return NFCDetail::all();
    }

    public function store(Request $request)
    {
        // التحقق من صحة البيانات: log_id إجباري ويجب أن يكون موجود في جدول nfc_logs
        $validated = $request->validate([
            'log_id' => 'required|exists:nfc_logs,nfc_logs_id',
            'action_time' => 'nullable|date',
        ]);

        $log = NfcLog::findOrFail($validated['log_id']);

        // جلب آخر حركة لنفس الطالب لتحديد نوع الحركة الجديدة
        $lastAction = $log->details()->latest('action_time')->first();

        $action_type = 'enter';
        if ($lastAction && $lastAction->action_type === 'enter') {
            $action_type = 'exit';
        }

        // منع التكرار خلال 10 ثواني
        if (
            $lastAction &&
            $lastAction->action_type === $action_type &&
            $lastAction->action_time &&
            $lastAction->action_time->diffInSeconds(now()) < 10
        ) {
            return response()->json([
                'message' => 'Duplicate tap ignored.',
                'status' => 'ignored',
            ], 200);
        }

        // إنشاء السجل الجديد في جدول nfc_details
        $detail = NFCDetail::create([
            'log_id' => $validated['log_id'],
            'action_type' => $action_type,
            'action_time' => $validated['action_time'] ?? now(),
        ]);

        // إرسال إشعار فوري عبر Firebase
        $factory = (new Factory)->withServiceAccount(storage_path('app/google-services.json'));
        $messaging = $factory->createMessaging();

        $title = '🚍 حركة جديدة للطالب';
        $body = 'الطالب #' . $log->student_id . ' قام بعملية ' . ($action_type === 'enter' ? 'الصعود إلى الحافلة' : 'النزول من الحافلة') . ' في ' . $detail->action_time->format('H:i:s');

        $message = CloudMessage::withTarget('topic', 'all')
            ->withNotification(FcmNotification::create($title, $body));

        $messaging->send($message);

        return response()->json($detail, 201);
    }

    public function show($id)
    {
        return NFCDetail::findOrFail($id);
    }

    public function update(Request $request, $id)
    {
        $detail = NFCDetail::findOrFail($id);
        $detail->update($request->all());
        return $detail;
    }

    public function destroy($id)
    {
        NFCDetail::destroy($id);
        return response()->noContent();
    }

    // Endpoint لمعرفة حالة الطالب الحالية (داخل أو خارج الحافلة)
    public function getStudentStatus($student_id)
    {
        $log = NfcLog::where('student_id', $student_id)->first();

        if (!$log) {
            return response()->json(['status' => 'unknown', 'message' => 'No log found'], 404);
        }

        $lastAction = $log->details()->latest('action_time')->first();

        if (!$lastAction) {
            return response()->json(['status' => 'outside', 'message' => 'No action recorded']);
        }

        $status = $lastAction->action_type === 'enter' ? 'inside' : 'outside';

        return response()->json([
            'student_id' => $student_id,
            'status' => $status,
            'last_action_time' => $lastAction->action_time,
        ]);
    }
}
