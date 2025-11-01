<?php

// namespace App\Http\Controllers\Api;

// use App\Http\Controllers\Controller;
// use App\Models\Payment;
// use Illuminate\Http\Request;
// use Illuminate\Support\Facades\Validator;
// use Illuminate\Support\Str;

// class PaymentController extends Controller
// {
//     public function store(Request $request)
//     {
//         // دمج البيانات العادية مع البيانات داخل payload (لو موجودة)
//         $requestData = array_merge(
//             $request->except('payload'),
//             $request->input('payload', [])
//         );

//         // التحقق من البيانات
//         $validator = Validator::make($requestData, [
//             'user_id' => 'required|exists:users,user_id',
//             'amount' => 'required|numeric|min:0.01',
//             'card_number' => 'required|string',
//             'card_name' => 'required|string',
//             'expiry_month' => 'required|digits:2',
//             'expiry_year' => 'required|digits:2',
//             'cvv' => 'required|digits_between:3,4',
//         ]);

//         if ($validator->fails()) {
//             return response()->json([
//                 'status' => 'failed',
//                 'message' => 'Validation error',
//                 'errors' => $validator->errors(),
//             ], 422);
//         }

//         $data = $validator->validated();

//         // منطق الدفع الوهمي
//         $card = preg_replace('/\s+/', '', $data['card_number']);
//         $isSuccess = str_starts_with($card, '4111');
//         $tx = 'FAKE-' . Str::upper(Str::random(10));
//         $status = $isSuccess ? 'success' : 'failed';

//         // إنشاء السجل في قاعدة البيانات
//         $payment = Payment::create([
//             'user_id' => $data['user_id'],
//             'transaction_id' => $tx,
//             'amount' => $data['amount'],
//             'status' => $status,
//             'payload' => [
//                 'request' => $data,
//                 'processed_at' => now()->toDateTimeString(),
//             ],
//         ]);

//         // النتيجة النهائية
//         if ($isSuccess) {
//             return response()->json([
//                 'status' => 'success',
//                 'message' => 'تم الدفع بنجاح (وهمي)',
//                 'transaction_id' => $tx,
//                 'payment' => $payment,
//             ], 200);
//         }

//         return response()->json([
//             'status' => 'failed',
//             'message' => 'فشل الدفع: بيانات البطاقة غير صحيحة',
//             'transaction_id' => $tx,
//             'payment' => $payment,
//         ], 400);
//     }

//     public function index()
//     {
//         return Payment::with('user')->latest()->get();
//     }
// }








namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Payment;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;

class PaymentController extends Controller
{
    // إضافة دفعة جديدة
    public function store(Request $request)
    {
        // جلب المستخدم من التوكن
        $user = $request->user();

        if (!$user) {
            return response()->json([
                'status' => 'failed',
                'message' => 'Unauthorized: invalid token'
            ], 401);
        }

        // دمج البيانات العادية مع payload لو موجودة
        $requestData = array_merge(
            $request->except('payload'),
            $request->input('payload', [])
        );

        // التحقق من البيانات
        $validator = Validator::make($requestData, [
            'amount' => 'required|numeric|min:0.01',
            'card_number' => 'required|string',
            'card_name' => 'required|string',
            'expiry_month' => 'required|digits:2',
            'expiry_year' => 'required|digits:2',
            'cvv' => 'required|digits_between:3,4',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'failed',
                'message' => 'Validation error',
                'errors' => $validator->errors(),
            ], 422);
        }

        $data = $validator->validated();

        // منطق الدفع الوهمي
        $card = preg_replace('/\s+/', '', $data['card_number']);
        $isSuccess = str_starts_with($card, '4111');
        $tx = 'FAKE-' . Str::upper(Str::random(10));
        $status = $isSuccess ? 'success' : 'failed';

        // إنشاء السجل في قاعدة البيانات
        $payment = Payment::create([
            'user_id' => $user->user_id, // استخدمي user_id في جدولك
            'transaction_id' => $tx,
            'amount' => $data['amount'],
            'status' => $status,
            'payload' => [
                'request' => $data,
                'processed_at' => now()->toDateTimeString(),
            ],
        ]);

        return response()->json([
            'status' => $isSuccess ? 'success' : 'failed',
            'message' => $isSuccess ? 'تم الدفع بنجاح ' : 'فشل الدفع: بيانات البطاقة غير صحيحة',
            'transaction_id' => $tx,
            'payment' => $payment,
        ], $isSuccess ? 200 : 400);
    }

    // عرض جميع المدفوعات للمستخدم الحالي
    public function index(Request $request)
    {
        $user = $request->user();

        if (!$user) {
            return response()->json([
                'status' => 'failed',
                'message' => 'Unauthorized: invalid token'
            ], 401);
        }

        $payments = Payment::where('user_id', $user->user_id)
                           ->latest()
                           ->get();

        return response()->json($payments);
    }
}
