<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Api\BaseController;
use Illuminate\Http\Request;
use App\Models\Student;
use App\Models\School;

class SchoolController extends BaseController
{
    // جلب جميع المدارس مع المنطقة
    public function index()
    {
        $schools = School::with('area')->get();
        return $this->sendResponse($schools, 'All schools retrieved successfully.');
    }

    // إنشاء مدرسة جديدة
    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'area_id' => 'required|exists:areas,area_id',
        ]);

        $school = School::create($request->all());
        return $this->sendResponse($school, 'School created successfully.');
    }

    // جلب مدرسة محددة
    public function show($id)
    {
        $school = School::with('area')->find($id);

        if (is_null($school)) {
            return $this->sendError('School not found.');
        }

        return $this->sendResponse($school, 'School retrieved successfully.');
    }

    // تحديث بيانات مدرسة
    public function update(Request $request, $id)
    {
        $school = School::find($id);

        if (is_null($school)) {
            return $this->sendError('School not found.');
        }

        $request->validate([
            'name' => 'string|max:255',
            'area_id' => 'exists:areas,area_id',
        ]);

        $school->update($request->all());
        return $this->sendResponse($school, 'School updated successfully.');
    }

    // حذف مدرسة
    public function destroy($id)
    {
        $school = School::find($id);

        if (is_null($school)) {
            return $this->sendError('School not found.');
        }

        $school->delete();
        return $this->sendResponse([], 'School deleted successfully.');
    }

    // جلب الحافلات بناءً على admin_id
    public function getSchoolBusesByAdmin($admin_id)
    {
        // جلب المدرسة التي يملكها الأدمن مع الحافلات والسائقين
        $school = School::with(['buses.driver'])
            ->where('admin_id', $admin_id)
            ->first();

        if (!$school) {
            return $this->sendError('School not found for this admin.');
        }

        // تجهيز البيانات
        $buses = $school->buses->map(function ($bus) {
            return [
                'bus_id'     => $bus->bus_id,
                'bus_number' => $bus->bus_number,
                'driver'     => $bus->driver ? $bus->driver->full_name : null
            ];
        });

        $data = [
            'school_id'   => $school->school_id,
            'school_name' => $school->name,
            'buses_count' => $buses->count(),
            'buses'       => $buses
        ];

        return $this->sendResponse($data, 'School buses retrieved successfully.');
    }
}
