<?php

namespace App\Http\Controllers;

use App\Http\Requests\StoreAdvertisementRequest;
use App\Models\Advertisement;
use App\Services\AdvertisementsService;

class AdvertisementController extends Controller
{
    public function __construct(protected AdvertisementsService $advertisementsService)
    {
    }

    public function index()
    {
        $advertisements = Advertisement::all();
        return response()->json($advertisements);
    }
    
    public function store(StoreAdvertisementRequest $request) 
    {
        $validated = $request->validated();

        [$zipPath, $zipFileName] = $this->advertisementsService->createAdvertisement(
            $validated['title'],
            $validated['image']
        );

        return response()->download($zipPath, $zipFileName);
    }

    public function trackAdvertisement($id)
    {
        $advertisement = Advertisement::find($id);

        if ($advertisement) {
            $advertisement->increment('visits');
            return response()->json(['message' => "Advertisement {$id} visit tracked."]);
        } else {
            return response()->json(['message' => 'Advertisement not found.'], 404);
        }
    }

    public function leadAdvertisement($id)
    {
        $advertisement = Advertisement::find($id);

        if ($advertisement) {
            $advertisement->increment('leads');
            return response()->json(['message' => "Advertisement {$id} lead tracked."]);
        } else {
            return response()->json(['message' => 'Advertisement not found.'], 404);
        }
    }
}
