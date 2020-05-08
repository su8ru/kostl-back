<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class UnyoPost extends Model
{
	protected $table = 'unyo_posts';

	/**
	 * The attributes that are mass assignable.
	 *
	 * @var array
	 */
	protected $fillable = [
		'id', 'unyo', 'vehicle', 'created_at'
	];

	protected $primaryKey = 'id';

	protected $keyType = 'int';

	public $incrementing = true;

	public $timestamps = true;

	const CREATED_AT = 'created_at';

	const UPDATED_AT = null;
}
