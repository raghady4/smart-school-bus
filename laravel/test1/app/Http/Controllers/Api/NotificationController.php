<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Notification;
use App\Models\NFCDetail;
use Kreait\Firebase\Factory;
use Kreait\Firebase\Messaging\CloudMessage;
use Kreait\Firebase\Messaging\Notification as FcmNotification;

class NotificationController extends Controller
{
    /**
     * جلب كل الإشعارات
     */
    public function index()
    {
        $notifications = Notification::latest()->get();
        return response()->json(['status' => 'success', 'data' => $notifications]);
    }

    /**
     * إرسال إشعار ثابت (يدوي) لجميع المشتركين
     */
    public function storeStaticNotification(Request $request)
    {
        $validated = $request->validate([
            'title' => 'required|string',
            'body' => 'required|string',
        ]);

        $factory = (new Factory)->withServiceAccount(
            storage_path('app/google-services.json')
        );
        $messaging = $factory->createMessaging();

        $message = CloudMessage::withTarget('topic', 'all')
            ->withNotification(FcmNotification::create(
                $validated['title'],
                $validated['body']
            ));

        $messaging->send($message);

        return response()->json(['status' => 'success', 'message' => 'Notification sent']);
    }

    /**
     * استقبال بيانات من الهاردوير وإرسال إشعار
     */
    public function storeFromHardware(Request $request)
    {
        $validated = $request->validate([
            // 'device_id' => 'required|integer',
            'student_id' => 'required|integer',
            'bus_id' => 'required|integer',
            'event' => 'required|string',
            'timestamp' => 'nullable|date',
        ]);

        // تخزين الحدث في سجل NFC
        $nfcdetail = NFCDetail::create($validated);

        // إرسال الإشعار عبر FCM
        $factory = (new Factory)->withServiceAccount(
            storage_path('app/google-services.json')
        );
        $messaging = $factory->createMessaging();

        $title = '🚍 NFC حدث جديد';
        $body = 'تم تسجيل حدث: ' . $validated['event'] . ' للطالب #' . $validated['student_id'];

        $message = CloudMessage::withTarget('topic', 'all')
            ->withNotification(FcmNotification::create($title, $body));

        $messaging->send($message);

        return response()->json(['status' => 'success', 'data' => $nfcdetail]);
    }
}
