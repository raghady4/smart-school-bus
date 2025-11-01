<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Api\BaseController;
use Illuminate\Http\Request;
use App\Models\Bus;
use App\Models\Student;
use App\Models\User;
use App\Http\Resources\BusResource;

class BusController extends BaseController
{
    public function index()
    {
        $buses = Bus::with(['driver', 'school', 'area', 'students'])->get();
        return $this->sendResponse(BusResource::collection($buses), 'All buses retrieved successfully.');
    }

    public function store(Request $request)
    {
        $request->validate([
            'school_id' => 'required|exists:schools,school_id',
            'area_id'   => 'required|exists:areas,area_id',
            'color'     => 'nullable|string',
        ]);

        // محاولة إيجاد باص بنفس المنطقة وعدد طلابه أقل من 20
        $bus = Bus::where('area_id', $request->area_id)
                  ->where('is_active', true)
                  ->withCount('students')
                  ->having('students_count', '<', 20)
                  ->orderByDesc('created_at')
                  ->first();

        if (!$bus) {
            // اختيار سائق عشوائي
            $driver = User::where('role', 'driver')->inRandomOrder()->first();

            $bus = Bus::create([
                'bus_number' => 'BUS-' . strtoupper(uniqid()),
                'school_id'  => $request->school_id,
                'area_id'    => $request->area_id,
                'color'      => $request->color,
                'driver_id'  => $driver->user_id,
                'is_active'  => true,
            ]);
        }

        return $this->sendResponse(new BusResource($bus), 'Bus assigned or created successfully.');
    }

    public function show($id)
    {
        $bus = Bus::with(['students', 'driver', 'school', 'area'])->find($id);
        if (!$bus) return $this->sendError('Bus not found.');

        return $this->sendResponse(new BusResource($bus), 'Bus retrieved successfully.');
    }

    public function destroy($id)
    {
        $bus = Bus::find($id);
        if (!$bus) return $this->sendError('Bus not found.');

        $bus->delete();
        return $this->sendResponse([], 'Bus deleted successfully.');
    }

    // الدالة الجديدة لجلب الطلاب باستخدام توكن السائق
    public function getStudentsForDriver(Request $request)
    {
        $user = auth()->user();

        if (!$user) {
            return $this->sendError('Unauthorized.', [], 401);
        }

        if ($user->role !== 'driver') {
            return $this->sendError('Only drivers can access their bus students.', [], 403);
        }

        // جلب الباص التابع للسائق مباشرة
        $bus = Bus::with(['students' => function ($query) {
            $query->select('student_id', 'full_name', 'address', 'bus_id');
        }, 'driver', 'school', 'area'])
        ->where('driver_id', $user->user_id)
        ->first();

        if (!$bus) {
            return $this->sendError('Bus not found for this driver.');
        }

        // تحضير بيانات الطلاب
        $students = $bus->students->map(function ($student) {
            return [
                'student_id' => $student->student_id,
                'full_name'  => $student->full_name,
                'address'    => $student->address,
            ];
        });

        $data = [
            'bus_id'         => $bus->bus_id,
            'bus_number'     => $bus->bus_number,
            'driver_name'    => $bus->driver->full_name ?? null,
            'students_count' => $students->count(),
            'students'       => $students,
            'school_name'    => $bus->school->name ?? null,
            'area_name'      => $bus->area->name ?? null,
        ];

        return $this->sendResponse($data, 'Bus and students retrieved successfully.');
    }
}
