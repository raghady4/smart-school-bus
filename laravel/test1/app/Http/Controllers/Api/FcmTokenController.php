<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\FcmToken;

class FcmTokenController extends Controller
{
    public function store(Request $request)
    {
        $request->validate([
            'token' => 'required|string',
        ]);

        FcmToken::updateOrCreate(
            ['token' => $request->token],
            [
                'user_id' => auth()->id(),
                'token' => $request->token,
            ]
        );

        return response()->json(['message' => 'Token saved successfully']);
    }
}
