<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\NfcLog;
use Illuminate\Http\Request;

class NfcLogController extends Controller
{
    // عرض جميع السجلات
    public function index()
    {
        return NfcLog::all();
    }

    // إنشاء سجل جديد (أو تحديث سجل غير مفعل)
    public function store(Request $request)
    {
        $validated = $request->validate([
            'student_id' => 'nullable|integer',
            'bus_id' => 'required|integer',
        ]);

        // البحث عن سجل غير مفعل لهذا الباص
        $inactiveLog = NfcLog::where('bus_id', $validated['bus_id'])
                             ->where('is_active', 0)
                             ->first();

        if (!$inactiveLog) {
            return response()->json(['error' => 'No inactive NFC log found for this bus'], 404);
        }

        // تحديث السجل: تعيين الطالب وتفعيل السجل
        $inactiveLog->update([
            'student_id' => $validated['student_id'],
            'is_active' => 1,
            'timestamp' => now(),
        ]);

        \Log::info('Updated inactive NFC log:', $inactiveLog->toArray());

        return response()->json($inactiveLog, 200);
    }

    // عرض سجل محدد
    public function show($id)
    {
        $nfcLog = NfcLog::findOrFail($id);
        return response()->json($nfcLog);
    }

    // تحديث سجل
    public function update(Request $request, $id)
    {
        $nfcLog = NfcLog::findOrFail($id);

        $validated = $request->validate([
            'student_id' => 'nullable|integer',
            'bus_id' => 'sometimes|integer',
            'is_active' => 'sometimes|boolean',
            'timestamp' => 'nullable|date',
        ]);

        $nfcLog->update($validated);
        return response()->json($nfcLog);
    }

    // حذف سجل
    public function destroy($id)
    {
        $nfcLog = NfcLog::findOrFail($id);
        $nfcLog->delete();
        return response()->json(['message' => 'Deleted successfully']);
    }
    public function getLogIdByUID(Request $request)
{
    $request->validate([
        'uid' => 'required|string'
    ]);

    $log = NfcLog::where('nfc_uid', $request->uid)->first();

    if (!$log) {
        return response()->json(['error' => 'UID not found'], 404);
    }

    return response()->json(['log_id' => $log->nfc_logs_id], 200);
}

}
