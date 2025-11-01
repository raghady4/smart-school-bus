<?php

namespace App\Http\Controllers\Api;

use Illuminate\Http\Request;
use App\Models\Location20;
use App\Http\Controllers\Controller;

class Location20Controller extends Controller
{
    // تخزين البيانات القادمة من OwnTracks
    public function store(Request $request)
    {
        // تسجيل البيانات الواردة للتأكد من الاستلام
        \Log::info('Received from OwnTracks (Location20):', $request->all());

        // خزّن فقط لو كانت رسالة موقع
        if ($request->input('_type') !== 'location') {
            return response()->json([
                'status' => 'ignored',
                'message' => 'Not a location message'
            ]);
        }

        // الحصول على timestamp من الجهاز إذا موجود، أو استخدام الوقت الحالي
        $timestamp = $request->input('tst')
            ? date('Y-m-d H:i:s', (int)$request->input('tst'))
            : now();

        // إنشاء سجل جديد دائمًا
        $location = Location20::create([
            'tracker_id' => $request->input('tid'),
            'latitude'   => $request->input('lat'),
            'longitude'  => $request->input('lon'),
            'altitude'   => $request->input('alt'),
            'accuracy'   => $request->input('acc'),
            'type'       => $request->input('_type'),
            'timestamp'  => $timestamp,
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Location saved',
            'data' => $location
        ]);
    }

    // عرض جميع المواقع
    public function index()
    {
        return response()->json(Location20::all());
    }

    // آخر موقع لجهاز معين
    public function latest($trackerId)
    {
        $location = Location20::where('tracker_id', $trackerId)
            ->latest('timestamp')
            ->first();

        if (!$location) {
            return response()->json(['message' => 'No location found'], 404);
        }

        return response()->json([
            'latitude' => $location->latitude,
            'longitude' => $location->longitude,
            'timestamp' => $location->timestamp,
        ]);
    }

    // آخر N مواقع لجهاز معين
    public function trail(Request $request, $trackerId)
    {
        $limit = (int) $request->query('limit', 50);

        $locations = Location20::where('tracker_id', $trackerId)
            ->orderByDesc('timestamp')
            ->limit($limit)
            ->get()
            ->reverse() // ترتيب من الأقدم للأحدث
            ->values();

        return response()->json($locations);
    }
}
