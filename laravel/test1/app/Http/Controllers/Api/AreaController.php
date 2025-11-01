<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Api\BaseController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use App\Models\Area;

class AreaController extends BaseController
{
    public function index()
    {
        $areas = Area::all();
        return $this->sendResponse($areas, 'All areas retrieved successfully.');
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|unique:areas,name',
        ]);

        if ($validator->fails()) {
            return $this->sendError('Validation error', $validator->errors());
        }

        $area = Area::create([
            'name' => $request->name,
        ]);

        return $this->sendResponse($area, 'Area created successfully.');
    }

    public function show($area_id)
    {
        $area = Area::find($area_id);

        if (is_null($area)) {
            return $this->sendError('Area not found.');
        }

        return $this->sendResponse($area, 'Area retrieved successfully.');
    }

    public function update(Request $request, $area_id)
    {
        $area = Area::find($area_id);

        if (is_null($area)) {
            return $this->sendError('Area not found.');
        }

        $validator = Validator::make($request->all(), [
            'name' => 'required|unique:areas,name,' . $area_id,
        ]);

        if ($validator->fails()) {
            return $this->sendError('Validation error.', $validator->errors());
        }

        $area->name = $request->name;
        $area->save();

        return $this->sendResponse($area, 'Area updated successfully.');
    }

    public function destroy($id)
    {
        $area = Area::find($id);

        if (is_null($area)) {
            return $this->sendError('Area not found.');
        }

        $area->delete();
        return $this->sendResponse([], 'Area deleted successfully.');
    }
}
