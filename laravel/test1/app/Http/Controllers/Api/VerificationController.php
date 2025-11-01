<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Auth\Events\Verified;
use Illuminate\Http\Request;

class VerificationController extends Controller
{
    /**
     * تأكيد البريد الإلكتروني
     */
    public function verify(Request $request, $id, $hash)
    {
        $user = User::findOrFail($id);

        // تأكد من صحة الرابط
        if (! hash_equals((string) $hash, sha1($user->getEmailForVerification()))) {
            return response()->json([
                'success' => false,
                'message' => 'Invalid verification link'
            ], 400);
        }

        // إذا البريد متحقق مسبقاً
        if ($user->hasVerifiedEmail()) {
            return response()->json([
                'success' => true,
                'message' => 'Email already verified'
            ]);
        }

        // تحقق البريد
        if ($user->markEmailAsVerified()) {
            event(new Verified($user));
        }

        // ✅ إنشاء توكن بعد التحقق
        $token = $user->createToken('SmartBus')->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => 'Email verified successfully',
            'token'   => $token,
            'user'    => $user,
        ]);
    }
}
