<?php

namespace App\Http\Controllers\Api;

use Illuminate\Support\Facades\Log;
use App\Http\Controllers\Api\BaseController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use App\Models\User;
use Validator;
use App\Http\Resources\UserResource;
use App\Notifications\VerifyEmailQueued;
use Illuminate\Auth\Notifications\VerifyEmail;
use App\Services\AesService;

class RegisterController extends BaseController
{
    public function register(Request $request)
    {
        // استقبل النص المشفر
        $encryptedPayload = $request->input('data');

        try {
            // فك التشفير
            $data = AesService::decrypt($encryptedPayload);
        } catch (\Exception $e) {
            return $this->sendError('Decryption Error', $e->getMessage());
        }

        $validator = Validator::make($data, [
            'full_name'  => 'required|string|max:255',
            'email'      => 'required|email|unique:users,email',
            'password'   => 'required|min:6',
            'c_password' => 'required|same:password',
            'phone'      => 'required|string|max:20',
            'role'       => 'required|in:admin,parent,driver',
        ]);

        if ($validator->fails()) {
            return $this->sendError('Validation Error', $validator->errors());
        }

        $input = $data;

        // تشفير الباسوورد
        $input['password'] = Hash::make($input['password']);

        // إذا كان ولي أمر، يتم تفعيل الحساب مباشرة
        $input['is_active'] = ($input['role'] === 'parent');

        // إنشاء المستخدم
        $user = User::create($input);

        // إنشاء نسخة مشفرة من الإيميل
        $encryptedEmail = AesService::encrypt($user->email);

        // تسجيل معلومات في اللوج
        Log::info('Entered register controller');
        Log::info('User email: ' . $user->email);
        Log::info('Encrypted email: ' . $encryptedEmail);
        Log::info('Trying to send verification email to: ' . $user->email);

        // إرسال إشعار التحقق
        $user->notify(new VerifyEmailQueued());

        return $this->sendResponse([
            'data' => $user->toArray(),
            'encrypted_email' => $encryptedEmail, // ✅ رجعنا الإيميل مشفر
        ], 'User registered successfully.');
    }

    public function login(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email'    => 'required|email',
            'password' => 'required',
        ]);

        if ($validator->fails()) {
            return $this->sendError('Validation Error', $validator->errors());
        }

        if (!Auth::attempt(['email' => $request->email, 'password' => $request->password])) {
            return $this->sendError('Unauthorized', ['error' => 'Email or password is incorrect.']);
        }

        $user = Auth::user();

        // التحقق من تفعيل الإيميل
        if (!$user->hasVerifiedEmail()) {
            return $this->sendError('Email not verified', ['error' => 'Please verify your email before login.']);
        }

        // التحقق من نشاط الحساب
        if (!$user->is_active) {
            return $this->sendError('Inactive Account', ['error' => 'Your account is not active.']);
        }

        // إنشاء التوكن
        $token = $user->createToken('SmartBus')->plainTextToken;

        // نسخة مشفرة من الإيميل
        $encryptedEmail = AesService::encrypt($user->email);

        return $this->sendResponse([
            'token' => $token,
            'user'  => new UserResource($user),
            'email_encrypted' => $encryptedEmail, // ✅ رجعنا الإيميل مشفر
        ], 'User logged in successfully.');
    }
}
