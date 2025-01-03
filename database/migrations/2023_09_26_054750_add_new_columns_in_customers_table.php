<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class AddNewColumnsInCustomersTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('customers', function (Blueprint $table) {
            $table->integer('score')->nullable();
            $table->integer('no_of_oc')->nullable();
            $table->integer('no_of_ac')->nullable();
            $table->integer('td')->nullable();
            $table->integer('ta')->nullable();
            $table->integer('d_to_ir')->nullable();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('customers', function (Blueprint $table) {
            $table->dropColumns([
                'score',
                'no_of_oc',
                'no_of_ac',
                'td',
                'ta',
                'd_to_ir',
            ]);
        });
    }
}
