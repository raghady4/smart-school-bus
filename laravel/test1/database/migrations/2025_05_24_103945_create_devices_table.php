<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{

    public function up(): void
    {
        Schema::create('devices', function (Blueprint $table) {
            $table->bigIncrements('devices_id');
            $table->unsignedBigInteger('bus_id');
            $table->string('name');
            $table->string('device_type');
            $table->string('device_identifier');
            $table->timestamps();

            $table->foreign('bus_id')->references('bus_id')->on('buses');
        });
    }


    public function down(): void
    {
        Schema::dropIfExists('devices');
    }
};
