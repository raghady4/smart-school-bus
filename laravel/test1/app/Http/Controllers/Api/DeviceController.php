<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Api\BaseController;
use Illuminate\Http\Request;
use App\Models\Device;
use Illuminate\Support\Facades\Validator;

class DeviceController extends BaseController
{
    public function index()
    {
        $devices = Device::with('bus')->get();
        return $this->sendResponse($devices, 'All devices retrieved successfully.');
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name'              => 'required|string|max:255',
            'device_type'       => 'required|string',
            'device_identifier' => 'required|string|unique:devices,device_identifier',
            'bus_id'           => 'required|exists:buses,bus_id',
        ]);

        if ($validator->fails()) {
            return $this->sendError('Validation Error', $validator->errors());
        }

        $device = Device::create($request->all());
        return $this->sendResponse($device, 'Device created successfully.');
    }

    public function show($id)
    {
        $device = Device::with('bus')->find($id);
        if (!$device)
            return $this->sendError('Device not found.');

        return $this->sendResponse($device, 'Device retrieved successfully.');
    }

    public function update(Request $request, $id)
    {
        $device = Device::find($id);
        if (!$device)
            return $this->sendError('Device not found.');

        $validator = Validator::make($request->all(), [
            'name'              => 'sometimes|string|max:255',
            'device_type'       => 'sometimes|string',
            'device_identifier' => 'sometimes|string|unique:devices,device_identifier,' . $id,
            'bus_id'           => 'sometimes|exists:buses,bus_id',
        ]);

        if ($validator->fails()) {
            return $this->sendError('Validation Error', $validator->errors());
        }

        $device->update($request->all());
        return $this->sendResponse($device, 'Device updated successfully.');
    }

    public function destroy($id)
    {
        $device = Device::find($id);
        if (!$device)
            return $this->sendError('Device not found.');

        $device->delete();
        return $this->sendResponse([], 'Device deleted successfully.');
    }
}
