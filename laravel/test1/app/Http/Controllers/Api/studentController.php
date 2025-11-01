<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Api\BaseController;
use Illuminate\Http\Request;
use App\Models\Student;
use App\Http\Resources\StudentResource;

class StudentController extends BaseController
{
    // عرض جميع الطلاب
    public function index()
    {
        $students = Student::with('parent', 'school', 'bus')->get();
        return $this->sendResponse(StudentResource::collection($students), 'All students retrieved successfully.');
    }

    // إنشاء طالب جديد
    public function store(Request $request)
{
    if (!auth()->check()) {
        return response()->json(['message' => 'Not Authenticated'], 401);
    }

    $parentId = auth()->id();
    $request->validate([
        'full_name' => 'required|string|max:255',
        'area_id' => 'required|exists:areas,area_id',
        'address' => 'sometimes|string',
        'school_id' => 'required|exists:schools,school_id',
        'bus_id' => 'required|exists:buses,bus_id',
    ]);

    $data = $request->all();
    $data['parent_id'] = $parentId;

    // ✅ البحث عن سوار NFC غير مستخدم في نفس الباص
    $availableNfcLog = \App\Models\NfcLog::whereNull('student_id')
        ->where('bus_id', $request->bus_id)
        ->where('is_active', 0)
        ->first();

        if (!$availableNfcLog || !$availableNfcLog->nfc_logs_id) {
    \Log::error('No available NFC found or nfc_logs_id is missing');
    return response()->json(['message' => 'No available NFC wristbands for this bus'], 400);
}


    if (!$availableNfcLog) {
        return response()->json(['message' => 'No available NFC wristbands for this bus'], 400);
    }

    // ربط السوار بالطالب وتفعيله
    $data['nfc_logs_id'] = $availableNfcLog->nfc_logs_id;

    $student = Student::create($data);

    $availableNfcLog->student_id = $student->student_id;
    $availableNfcLog->is_active = 1;
    $availableNfcLog->save();

    return $this->sendResponse(
        new StudentResource($student->load('parent', 'school', 'bus')),
        'Student created and NFC wristband assigned successfully.'
    );
}



    public function show($id)
    {
        $student = Student::with('parent', 'school', 'bus')->find($id);

        if (is_null($student)) {
            return $this->sendError('Student not found.');
        }

        return $this->sendResponse(new StudentResource($student), 'Student retrieved successfully.');
    }

    // تحديث بيانات طالب
    public function update(Request $request, $id)
    {
        $student = Student::find($id);

        if (is_null($student)) {
            return $this->sendError('Student not found.');
        }

        $request->validate([
            'full_name' => 'sometimes|string|max:255',
            'area_id' => 'required|exists:areas,area_id',
            'address' => 'sometimes|string',
            'school_id' => 'sometimes|exists:schools,school_id',
            'nfc_logs_id' => 'sometimes|unique:students,nfc_logs_id,' . $id . ',student_id',
            'parent_id' => 'sometimes|exists:users,user_id',
            'bus_id' => 'nullable|exists:buses,bus_id',
        ]);

        $student->update($request->all());
        return $this->sendResponse(new StudentResource($student->load('parent', 'school', 'bus')), 'Student updated successfully.');
    }

    // حذف طالب
    public function destroy($id)
    {
        $student = Student::find($id);
        if (!$student)
            return $this->sendError('Student not found.');

        $student->delete();
        return $this->sendResponse([], 'Student deleted successfully.');
    }
    //عرض الطلاب حسب الاب
    public function getStudentsByParent()
{

    if (!auth()->check()) {
        return response()->json(['message' => 'Not Authenticated'], 401);
    }

    $parentId = auth()->id();

    $students = Student::with('parent', 'school', 'bus')
        ->where('parent_id', $parentId)
        ->get();

    return $this->sendResponse(StudentResource::collection($students), 'Students retrieved successfully for current parent.');
}


}
