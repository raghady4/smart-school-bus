<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Api\BaseController;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Str;
use Illuminate\Http\Request;
use App\Models\User;
use App\Mail\ResetPasswordTokenMail;
use Carbon\Carbon;

class PasswordResetController extends BaseController
{
    // إرسال رمز الاستعادة (Token) عبر الإيميل
public function sendResetLink(Request $request)
{
    $request->validate(['email' => 'required|email']);

    $user = User::where('email', $request->email)->first();

    if (!$user) {
        return $this->sendError('المستخدم غير موجود', ['email' => 'لا يوجد مستخدم بهذا البريد']);
    }

    // توليد رمز استعادة جديد
    $token = Str::random(60);

    // حذف المحاولات السابقة لنفس الإيميل
    DB::table('password_resets')->where('email', $request->email)->delete();

    // حفظ الرمز في جدول password_resets
    DB::table('password_resets')->insert([
        'email' => $request->email,
        'token' => Hash::make($token),
        'created_at' => Carbon::now(),
    ]);

    // إرسال الرمز كبريد نصي خام بدون View
    \Mail::raw("رمز استعادة كلمة المرور الخاص بك هو:\n\n$token\n\nإذا لم تطلبي استعادة كلمة المرور، يرجى تجاهل هذا البريد.", function ($message) use ($request) {
        $message->to($request->email)
                ->subject('رمز استعادة كلمة المرور');
    });

    return $this->sendResponse([
        'token' => $token,
        'email' => $request->email,
    ], 'تم إرسال رمز الاستعادة إلى بريدك الإلكتروني.');
}


    // إعادة تعيين كلمة المرور داخل التطبيق
    public function reset(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'token' => 'required|string',
            'password' => 'required|confirmed|min:6',
        ]);

        $record = DB::table('password_resets')
            ->where('email', $request->email)
            ->first();

        if (!$record) {
            return $this->sendError('الرابط غير صالح أو منتهي الصلاحية.', ['token' => 'لا يوجد رمز لهذا البريد']);
        }

        if (!Hash::check($request->token, $record->token)) {
            return $this->sendError('رمز غير صالح.', ['token' => 'رمز الاستعادة غير صحيح']);
        }

        $user = User::where('email', $request->email)->first();

        if (!$user) {
            return $this->sendError('المستخدم غير موجود', ['email' => 'لا يوجد مستخدم بهذا البريد']);
        }

        $user->forceFill([
            'password' => Hash::make($request->password),
            'remember_token' => Str::random(60),
        ])->save();

        DB::table('password_resets')->where('email', $request->email)->delete();

        return $this->sendResponse([], 'تم إعادة تعيين كلمة المرور بنجاح.');
    }
}
