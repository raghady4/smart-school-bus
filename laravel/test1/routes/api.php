<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Services\FirebaseService;
use App\Models\User;
use Illuminate\Support\Facades\URL;
use App\Http\Controllers\Api\PaymentController;
use Illuminate\Foundation\Auth\EmailVerificationRequest;
use App\Http\Controllers\Api\{
    RegisterController,
    PasswordResetController,
    FcmTokenController,
    NotificationController,
    AreaController,
    SchoolController,
    BusController,
    StudentController,
    DeviceController,
    SensorController,
    NfcLogController,
    NFCDetailController,
    VerificationController,
    Location20Controller


};


// ===================
// ✅ Public Routes
// ===================

// Auth
Route::post('register', [RegisterController::class, 'register']);
Route::post('login', [RegisterController::class, 'login']);
Route::post('forgot-password', [PasswordResetController::class, 'sendResetLink']);
Route::post('reset-password', [PasswordResetController::class, 'reset']);

// FCM
Route::post('save-fcm-token', [FcmTokenController::class, 'store']);

// Firebase Notification Test
Route::post('send-notification', function (Request $request, FirebaseService $firebaseService) {
    try {
        $firebaseService->sendNotification(
            $request->input('token'),
            $request->input('title'),
            $request->input('body')
        );
        return response()->json(['status' => 'sent']);
    } catch (\Exception $e) {
        \Log::error('Firebase notification failed: ' . $e->getMessage());
        return response()->json(['status' => 'error', 'message' => $e->getMessage()], 500);
    }
});

// ===================
// ✅ Protected Routes (Need Sanctum Token)
// ===================
Route::middleware('auth:sanctum')->group(function () {

    // Get logged-in user
    Route::get('/user', function (Request $request) {
        return $request->user();
    });

    // Area, School, Bus
    Route::apiResource('areas', AreaController::class);

    Route::apiResource('schools', SchoolController::class);
    // Route::get('schools/buses', [SchoolController::class, 'getSchoolBuses']);
    // Route::get('schools/buses', [SchoolController::class, 'getSchoolBuses'])
    //  ->middleware('auth:sanctum');






// استرجاع كل المدارس
Route::get('schools', [SchoolController::class, 'index']);

// إنشاء مدرسة جديدة
// إنشاء مدرسة جديدة
Route::post('schools', [SchoolController::class, 'store'])->middleware('auth:sanctum');

// استرجاع مدرسة معينة
Route::get('schools/{id}', [SchoolController::class, 'show'])->middleware('auth:sanctum');

// تحديث مدرسة
Route::put('schools/{id}', [SchoolController::class, 'update'])->middleware('auth:sanctum');

// حذف مدرسة
Route::delete('schools/{id}', [SchoolController::class, 'destroy'])->middleware('auth:sanctum');

// استرجاع حافلات المدرسة الخاصة باليوزر المتصل (باستخدام admin_id)
Route::get('schools/{admin_id}/buses', [SchoolController::class, 'getSchoolBusesByAdmin'])
     ->middleware('auth:sanctum');




    Route::apiResource('buses', BusController::class)->except(['update']);

    // ✅ عرض الطلاب حسب الباص


// مسار لجلب الطلاب للباص باستخدام توكن السائق
Route::middleware('auth:sanctum')->get('/driver/bus-students', [BusController::class, 'getStudentsForDriver']);

    // Route::middleware('auth:api')->get('buses/students', [BusController::class, 'getStudentsByToken']);
// Students
    Route::get('student', [StudentController::class, 'index']);
    Route::post('student', [StudentController::class, 'store']);
    Route::get('student/{id}', [StudentController::class, 'show']);
    Route::put('student/{id}', [StudentController::class, 'update']);
    Route::delete('student/{id}', [StudentController::class, 'destroy']);
    Route::get('my-students', [StudentController::class, 'getStudentsByParent']);
    Route::get('student-status/{student_id}', [NFCDetailController::class, 'getStudentStatus']); // ✅ Get in/out status
// Devices & Sensors
    Route::apiResource('devices', DeviceController::class);
    Route::get('sensors', [SensorController::class, 'index']);
    Route::get('sensors/{id}', [SensorController::class, 'show']);
    Route::post('devices/{device}/sensors', [SensorController::class, 'store']);
    Route::match(['put', 'patch'], 'sensors/{id}', [SensorController::class, 'update']);
    Route::delete('sensors/{id}', [SensorController::class, 'destroy']);

    // NFC Logs & Details
    Route::get('nfc-logs', [NfcLogController::class, 'index']);
    Route::get('nfc-logs/{id}', [NfcLogController::class, 'show']);
    // Route::post('devices/{device}/nfc-logs', [NfcLogController::class, 'store']);
    Route::match(['put', 'patch'], 'nfc-logs/{id}', [NfcLogController::class, 'update']);
    Route::delete('nfc-logs/{id}', [NfcLogController::class, 'destroy']);

    Route::apiResource('nfc-details', NFCDetailController::class);
    // Route::post('devices/{device}/nfc-details', [NFCDetailController::class, 'store']);
    // أضف هذا خارج مجموعة الـ middleware:





    // // Notifications
    // Route::get('notifications', [NotificationController::class, 'index']);
    // Route::post('notifications', [NotificationController::class, 'store']);

Route::get('/notifications', [NotificationController::class, 'index']);
Route::post('/notifications/static', [NotificationController::class, 'storeStaticNotification']);
Route::post('/notifications/hardware', [NotificationController::class, 'storeFromHardware']);

});
Route::post('nfc-details', [NFCDetailController::class, 'store']);
Route::get('nfc-log-by-uid/{uid}', [NfcLogController::class, 'getLogByUid']);
Route::post('/nfc-logs/fetch-log-id', [NfcLogController::class, 'getLogIdByUID']);

//payment




// // إضافة دفعة جديدة
// Route::post('/payments', [PaymentController::class, 'store']);

// // عرض جميع المدفوعات
// Route::get('/payments', [PaymentController::class, 'index']);



// إضافة دفعة جديدة – محمي بالتوكن
Route::middleware('auth:sanctum')->post('/payments', [PaymentController::class, 'store']);

// عرض جميع المدفوعات – محمي بالتوكن
Route::middleware('auth:sanctum')->get('/payments', [PaymentController::class, 'index']);



// إرسال رابط تحقق جديد
Route::post('/email/verification-notification', function (Request $request) {
    if ($request->user()->hasVerifiedEmail()) {
    return response()->json(['message' => 'Email already verified']);
}
    $request->user()->sendEmailVerificationNotification();
    return response()->json(['message' => 'Verification link sent!']);
})->middleware('auth:sanctum');



// التحقق من الرابط لما يضغط المستخدم على الإيميل
// Route::get('/email/verify/{id}/{hash}', function (EmailVerificationRequest $request) {
//     $request->fulfill(); // يفعّل الإيميل
//     return '<h1>Email verified successfully!</h1><p>You can now return to the app.</p>';
// })->middleware(['signed'])->name('verification.verify');


Route::get('/email/verify/{id}/{hash}', function ($id, $hash) {
    $user = User::findOrFail($id);

    if (! hash_equals(sha1($user->getEmailForVerification()), (string) $hash)) {
        abort(403, 'Invalid verification link');
    }

    if ($user->hasVerifiedEmail()) {
        return '<h1>Email already verified</h1>';
    }

    $user->markEmailAsVerified();

    return '<h1>Email verified successfully!</h1><p>You can now return to the app.</p>';
})->middleware(['signed'])->name('verification.verify');


Route::get('/email/verify/{id}/{hash}', [VerificationController::class, 'verify'])
    ->name('verification.verify');




Route::post('/location20/store', [Location20Controller::class, 'store']);
Route::get('/location20', [Location20Controller::class, 'index']);
Route::get('/location20/latest/{trackerId}', [Location20Controller::class, 'latest']);
