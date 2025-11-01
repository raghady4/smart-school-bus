<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::table('schools', function (Blueprint $table) {
            $table->unsignedBigInteger('admin_id')->nullable()->after('name');
            $table->foreign('admin_id')->references('user_id')->on('users')->onDelete('set null');
        });
    }

    public function down()
    {
        Schema::table('schools', function (Blueprint $table) {
            $table->dropForeign(['admin_id']); // أولاً إزالة الفوريجن
            $table->dropColumn('admin_id');    // ثم إزالة العمود
        });
    }
};
