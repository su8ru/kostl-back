<?php

namespace App\Http\Controllers;

use App\Models\UnyoPost;
use Illuminate\Http\Request;

class UnyoPostController extends Controller
{
    public function get() {
    	$all = UnyoPost::all();

    	$obj = [];

    	foreach ($all as $i) {
    		if (!array_key_exists($i['unyo'], $obj))
				$obj[$i['unyo']] = [];

    		array_push($obj[$i['unyo']], [ 'vehicle' => $i['vehicle'], 'timestamp' => $i['created_at'] ]);
		}

    	return response()->json($obj);
	}

	public function post(Request $request) {
    	$this->validate($request, [
    		'unyo' => ['required', 'string'],
			'vehicle' => ['required', 'string', 'regex:/\d{3,4}F(\+\d{3,4}F)?/']
		]);

		$post = UnyoPost::create([
			'unyo' => $request->input('unyo'),
			'vehicle' => $request->input('vehicle')
		]);

    	return response($post, 201);
	}
}
