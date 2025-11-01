<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {

    public function up(): void
    {
        Schema::create('sensors', function (Blueprint $table) {
            $table->bigIncrements('sensor_id');
            $table->unsignedBigInteger('device_id');
            $table->json('data'); // مثال: motion, temperature, etc.
            $table->timestamps();

            // العلاقة مع devices
            $table->foreign('device_id')->references('devices_id')->on('devices')->onDelete('cascade');
        });
    }


    public function down(): void
    {
        Schema::dropIfExists('sensors');
    }
};
