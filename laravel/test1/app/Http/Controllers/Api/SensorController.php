<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Sensor;
use App\Models\Device;
use App\Models\FcmToken;
use Illuminate\Http\Request;
use Kreait\Firebase\Factory;
use Kreait\Firebase\Messaging\CloudMessage;
use Kreait\Firebase\Messaging\Notification as FcmNotification;

class SensorController extends Controller
{
    // عرض كل الحساسات
    public function index()
    {
        return response()->json(Sensor::with('device')->get(), 200);
    }

    // إنشاء حساس جديد + إرسال إشعار
    public function store(Request $request, $deviceId)
    {
        $request->validate([
            'data' => 'required|array'
        ]);

        $device = Device::find($deviceId);
        if (!$device) {
            return response()->json(['message' => 'Device not found'], 404);
        }

        $sensor = Sensor::create([
            'device_id' => $deviceId,
            'data' => $request->data
        ]);

        // إرسال الإشعار
        try {
            $factory = (new Factory)->withServiceAccount(storage_path('app/firebase_service_account.json'));
            $messaging = $factory->createMessaging();

            $tokens = FcmToken::pluck('token')->toArray();

            foreach ($tokens as $token) {
                $message = CloudMessage::new()
                    ->withNotification(FcmNotification::create(
                        '📡 قراءة جديدة من الحساس',
                        'تم تسجيل قراءة من الجهاز: ' . $device->name
                    ))
                    ->withToken($token);

                $messaging->send($message);
            }

        } catch (\Exception $e) {
            \Log::error('فشل إرسال الإشعار: ' . $e->getMessage());
        }

        return response()->json($sensor, 201);
    }

    // عرض حساس معين
    public function show($id)
    {
        $sensor = Sensor::with('device')->findOrFail($id);
        return response()->json($sensor);
    }

    // تحديث حساس
    public function update(Request $request, $id)
    {
        $sensor = Sensor::findOrFail($id);

        $validated = $request->validate([
            'type' => 'sometimes|string',
            'status' => 'nullable|string',
        ]);

        $sensor->update($validated);

        return response()->json($sensor);
    }

    // حذف حساس
    public function destroy($id)
    {
        $sensor = Sensor::findOrFail($id);
        $sensor->delete();

        return response()->json(['message' => 'Sensor deleted successfully.']);
    }
}
