class FbxCamera : FbxNodeAttribute /NoDefaultCtors/
{
public:
    static FbxClassId ClassId;
    static FbxCamera* Create(FbxManager *pManager, const char *pName);
    virtual FbxClassId GetClassId() const;
    static FbxCamera* Create(FbxObject *pContainer,  const char *pName);

    bool operator==(const FbxCamera & pObj);
    
    virtual FbxNodeAttribute::EType GetAttributeType() const;
    void Reset();

    enum EProjectionType
    {
        ePerspective,	//!< Perspective projection.
        eOrthogonal		//!< Orthogonal projection.
    };

	enum EFormat
	{
		eCustomFormat,	//!< The format's width, height, or pixel ratio has been user-specified, and matches none of the other picture formats.
		eD1NTSC,		//!< Standard format for D1 NTSC (720 by 486).
		eNTSC,			//!< NTSC standard for North American television broadcast (640 by 480).
		ePAL,			//!< PAL standard for European television broadcast (570 by 486).
		eD1PAL,			//!< Standard format for D1 PAL (720 by 576).
		eHD,			//!< HD format(1920 by 1080).
		e640x480,		//!< Recommended computer screen format (640 by 480).
		e320x200,		//!< Recommended format for World Wide Web production(320 by 200).
		e320x240,		//!< Alternate World Wide Web format(320 by 240).
		e128x128,		//!< Format(128 by 128)
		eFullscreen		//!< Full computer screen format (1280 by 1024 pixels).
	};

    void SetFormat(EFormat pFormat);
    EFormat GetFormat() const;
    
	enum EAspectRatioMode
	{
		eWindowSize,		//!< Both width and height values aren't relevant.
		eFixedRatio,		//!< The height value is set to 1.0 and the width value is relative to the height value.
		eFixedResolution,	//!< Both width and height values are in pixels.
		eFixedWidth,		//!< The width value is in pixels and the height value is relative to the width value.
		eFixedHeight		//!< The height value is in pixels and the width value is relative to the height value.
	};
    
    void SetAspect(EAspectRatioMode pRatioMode, double pWidth, double pHeight);
    EAspectRatioMode GetAspectRatioMode() const;
    void SetPixelRatio(double pRatio);
    double GetPixelRatio() const;
    void SetNearPlane(double pDistance);
    double GetNearPlane() const;
    void SetFarPlane(double pDistance);
    double GetFarPlane() const;

    enum EApertureFormat
    {
		eCustomAperture,	//!< The film size, squeeze ratio and aspect ratio has been user-specified, and matches none of the other aperture formats.
        e16mmTheatrical,	//!< Film Size: 0.404, 0.295 inches. Film Squeeze Ratio: 1.0. Film Aspect Ratio: 1.369.
        eSuper16mm,			//!< Film Size: 0.493, 0.292 inches. Film Squeeze Ratio: 1.0. Film Aspect Ratio: 1.688.
        e35mmAcademy,		//!< Film Size: 0.864, 0.630 inches. Film Squeeze Ratio: 1.0. Film Aspect Ratio: 1.371. 
        e35mmTVProjection,	//!< Film Size: 0.816, 0.612 inches. Film Squeeze Ratio: 1.0. Film Aspect Ratio: 1.333.
        e35mmFullAperture,	//!< Film Size: 0.980, 0.735 inches. Film Squeeze Ratio: 1.0. Film Aspect Ratio: 1.333.
        e35mm185Projection,	//!< Film Size: 0.825, 0.446 inches. Film Squeeze Ratio: 1.0. Film Aspect Ratio: 1.850.
        e35mmAnamorphic,	//!< Film Size: 0.864, 0.732 inches. Film Squeeze Ratio: 2.0. Film Aspect Ratio:1.180. 
        e70mmProjection,	//!< Film Size: 2.066, 0.906 inches. Film Squeeze Ratio: 1.0. Film Aspect Ratio: 2.280.
        eVistaVision,		//!< Film Size: 1.485, 0.991 inches. Film Squeeze Ratio: 1.0. Film Aspect Ratio: 1.498.
        eDynaVision,		//!< Film Size: 2.080, 1.480 inches. Film Squeeze Ratio: 1.0. Film Aspect Ratio: 1.405.
        eIMAX				//!< Film Size: 2.772, 2.072 inches. Film Squeeze Ratio: 1.0. Film Aspect Ratio: 1.338.
    };

    void SetApertureFormat(EApertureFormat pFormat);
    EApertureFormat GetApertureFormat() const;
    
    enum EApertureMode
    {
		eHorizAndVert,	//!< Set the angle values for both the horizontal and vertical settings. 
        eHorizontal,	//!< Set only the horizontal angle. 
        eVertical,		//!< Set only the vertical angle. 
        eFocalLength	//!< Use focal length directly. 
    };

    void SetApertureMode(EApertureMode pMode);
    EApertureMode GetApertureMode() const;
    void SetApertureWidth(double pWidth);
    double GetApertureWidth() const;
    void SetApertureHeight(double pHeight);
    double GetApertureHeight() const;
    void SetSqueezeRatio(double pRatio);
    double GetSqueezeRatio() const;

    enum EGateFit
    {
        eFitNone,		//!< No resolution gate fit.
        eFitVertical,	//!< Fit the resolution gate vertically within the film gate.
        eFitHorizontal,	//!< Fit the resolution gate horizontally within the film gate.
        eFitFill,		//!< Fit the resolution gate within the film gate.
        eFitOverscan,	//!< Fit the film gate within the resolution gate.
        eFitStretch		//!< Fit the resolution gate to the film gate.
    };

    double ComputeFieldOfView(double pFocalLength) const;
    double ComputeFocalLength(double pAngleOfView) const;
    
    enum EFilmRollOrder
    {
        eRotateFirst,	//!< The film back is first rotated then translated by the pivot point value.
        eTranslateFirst	//!< The film back is first translated then rotated by the film roll value.
    };

    void SetBackgroundFileName(const char* pFileName);
    const char * GetBackgroundFileName() const;
    void SetBackgroundMediaName(const char* pFileName);
    const char * GetBackgroundMediaName() const;
    
    enum EPlateDrawingMode
    {
        ePlateBackground,	//!< Image is drawn behind models.
        ePlateForeground,	//!< Image is drawn in front of models based on alpha channel.
        ePlateBackAndFront	//!< Image is drawn behind and in front of models depending on alpha channel.
    };

    void SetBackgroundAlphaTreshold(double pThreshold);
    double GetBackgroundAlphaTreshold() const;
    void SetBackPlateFitImage(bool pFitImage);
    bool GetBackPlateFitImage() const;
    void SetBackPlateCrop(bool pCrop);
    bool GetBackPlateCrop() const;
    void SetBackPlateCenter(bool pCenter);
    bool GetBackPlateCenter() const;
    void SetBackPlateKeepRatio(bool pKeepRatio);
    bool GetBackPlateKeepRatio() const;

    void SetShowFrontPlate(bool pEnable);
    bool GetShowFrontPlate() const;
    void SetFrontPlateFitImage(bool pFrontPlateFitImage);
    bool GetFrontPlateFitImage() const;
    void SetFrontPlateCrop(bool pFrontPlateCrop);
    bool GetFrontPlateCrop() const;
    void SetFrontPlateCenter(bool pFrontPlateCenter);
    bool GetFrontPlateCenter() const;
    void SetFrontPlateKeepRatio(bool pFrontPlateKeepRatio);
    bool GetFrontPlateKeepRatio() const;
    void SetForegroundOpacity(double pOpacity);
    double GetForegroundOpacity() const;
    void SetForegroundTexture(FbxTexture* pTexture);
    FbxTexture* GetForegroundTexture() const;

    enum EFrontBackPlaneDistanceMode
    {
        eRelativeToInterest,	//!< The back plane distance is measured in relation to the camera interest.
        eRelativeToCamera		//!< The back plane distance is measured in relation to the camera.
    };

    void SetBackPlaneDistanceMode(EFrontBackPlaneDistanceMode pMode);
    EFrontBackPlaneDistanceMode GetBackPlaneDistanceMode() const;
    void SetFrontPlaneDistance(double pDistance);
    double GetFrontPlaneDistance() const;
    void SetFrontPlaneDistanceMode(EFrontBackPlaneDistanceMode pMode);
    EFrontBackPlaneDistanceMode GetFrontPlaneDistanceMode() const;
    
    enum EFrontBackPlaneDisplayMode
    {
        ePlanesDisabled,	//!< Disables the front/back plane whether a texture is being projected or not.
        ePlanesAlways,		//!< Always shows the front/back plane, even if no texture has been added.
        ePlanesWhenMedia	//!< Shows the front/back plane only if a texture has been added.
    };
	
    void SetViewFrustumFrontPlaneMode(EFrontBackPlaneDisplayMode pMode);
    EFrontBackPlaneDisplayMode GetViewFrustumFrontPlaneMode() const;
    void SetViewFrustumBackPlaneMode(EFrontBackPlaneDisplayMode pMode);
    EFrontBackPlaneDisplayMode GetViewFrustumBackPlaneMode() const;

    void SetViewCameraInterest(bool pEnable);
    bool GetViewCameraInterest() const;
    void SetViewNearFarPlanes(bool pEnable);
    bool GetViewNearFarPlanes() const;

    enum ESafeAreaStyle
    {
		eSafeAreaRound,	//!< Rounded safe area.
        eSafeAreaSquare	//!< Square safe area.
    };

    enum ERenderOptionsUsageTime
    {
        eInteractive,	//!< To render in real time.
        eOnDemand		//!< Only render when it is asked.
    };

    enum EAntialiasingMethod
    {
        eAAOversampling,	//!< To do anti-aliasing by oversampling.
        eAAHardware			//!< To do anti-aliasing by hardware.
    };

    enum ESamplingType
    {
		eSamplingUniform,	/*!<	The Uniform method samples each pixel at the same location. 
									The pixel is divided into equal parts, and each part is sampled. 
									The number of samples determines the number of times the pixel is divided. */
		eSamplingStochastic	/*!<	The Stochastic method randomly samples each pixel. 
									This produces an accurate color using a small number of samples. */
    };

    enum EFocusDistanceSource
    {
        eFocusSrcCameraInterest,	/*!<	Base the depth of field on the camera interest. Models at the camera interest are in focus. 
											As you move toward or away from the camera interest, models become increasingly blurred. */
        eFocusSpecificDistance		//!<	Base the depth of field on a point defined by a specific distance from the camera interest.
    };

    bool IsBoundingBoxInView( const FbxMatrix& pWorldToScreen, 
                             const FbxMatrix& pWorldToCamera, 
                             const FbxVector4* pPoints /In/) const;
    bool IsPointInView( const FbxMatrix& pWorldToScreen, const FbxMatrix& pWorldToCamera, const FbxVector4& pPoint ) const;
    FbxMatrix ComputeWorldToScreen(int pPixelWidth, int pPixelHeight, const FbxAMatrix& pWorldToCamera) const;

    FbxPropertyDouble3                       Position;
    FbxPropertyDouble3                       UpVector;
    FbxPropertyDouble3                       InterestPosition;
    FbxPropertyDouble1                       Roll;
    FbxPropertyDouble1                       OpticalCenterX;
    FbxPropertyDouble1                       OpticalCenterY;
    FbxPropertyDouble3                       BackgroundColor;
    FbxPropertyDouble1                       TurnTable;
    FbxPropertyBool1                         DisplayTurnTableIcon;
    FbxPropertyBool1                         UseMotionBlur;
    FbxPropertyBool1                         UseRealTimeMotionBlur;
    FbxPropertyDouble1                       MotionBlurIntensity;
    FbxPropertyEAspectRatioMode              AspectRatioMode;
    FbxPropertyDouble1                       AspectWidth;
    FbxPropertyDouble1                       AspectHeight;
    FbxPropertyDouble1                       PixelAspectRatio;
    FbxPropertyEApertureMode                 ApertureMode;
    FbxPropertyEGateFit                      GateFit;
    FbxPropertyDouble1                       FieldOfView;
    FbxPropertyDouble1                       FieldOfViewX;
    FbxPropertyDouble1                       FieldOfViewY;
    FbxPropertyDouble1                       FocalLength;
    FbxPropertyEFormat                       CameraFormat;
    FbxPropertyBool1                         UseFrameColor;
    FbxPropertyDouble3                       FrameColor;
    FbxPropertyBool1                         ShowName;
    FbxPropertyBool1                         ShowInfoOnMoving;
    FbxPropertyBool1                         ShowGrid;
    FbxPropertyBool1                         ShowOpticalCenter;
    FbxPropertyBool1                         ShowAzimut;
    FbxPropertyBool1                         ShowTimeCode;
    FbxPropertyBool1                         ShowAudio;
    FbxPropertyDouble3                       AudioColor;
    FbxPropertyDouble1                       NearPlane;
    FbxPropertyDouble1                       FarPlane;
    FbxPropertyBool1                         AutoComputeClipPlanes;
    FbxPropertyDouble1                       FilmWidth;
    FbxPropertyDouble1                       FilmHeight;
    FbxPropertyDouble1                       FilmAspectRatio;
    FbxPropertyDouble1                       FilmSqueezeRatio;
    FbxPropertyEApertureFormat               FilmFormat;
    FbxPropertyDouble1                       FilmOffsetX;
    FbxPropertyDouble1                       FilmOffsetY;
    FbxPropertyDouble1                       PreScale;
    FbxPropertyDouble1                       FilmTranslateX;
    FbxPropertyDouble1                       FilmTranslateY;
    FbxPropertyDouble1                       FilmRollPivotX;
    FbxPropertyDouble1                       FilmRollPivotY;
    FbxPropertyDouble1                       FilmRollValue;
    FbxPropertyEFilmRollOrder                FilmRollOrder ;
    FbxPropertyBool1                         ViewCameraToLookAt;
    FbxPropertyBool1                         ViewFrustumNearFarPlane;
    FbxPropertyEFrontBackPlaneDisplayMode	 ViewFrustumBackPlaneMode;
    FbxPropertyDouble1                       BackPlaneDistance;
    FbxPropertyEFrontBackPlaneDistanceMode	 BackPlaneDistanceMode;
    FbxPropertyEFrontBackPlaneDisplayMode	 ViewFrustumFrontPlaneMode;
    FbxPropertyDouble1                       FrontPlaneDistance;
    FbxPropertyEFrontBackPlaneDistanceMode	 FrontPlaneDistanceMode;
    FbxPropertyBool1                         LockMode;
    FbxPropertyBool1                         LockInterestNavigation;
    FbxPropertyBool1                         BackPlateFitImage;
    FbxPropertyBool1                         BackPlateCrop;
    FbxPropertyBool1                         BackPlateCenter;
    FbxPropertyBool1                         BackPlateKeepRatio;
    FbxPropertyDouble1                       BackgroundAlphaTreshold;
    FbxPropertyDouble1                       BackPlaneOffsetX;
    FbxPropertyDouble1                       BackPlaneOffsetY;
    FbxPropertyDouble1                       BackPlaneRotation;
    FbxPropertyDouble1                       BackPlaneScaleX;
    FbxPropertyDouble1                       BackPlaneScaleY;
    FbxPropertyBool1                         ShowBackplate;
    FbxPropertyFbxReference                  BackgroundTexture;
    FbxPropertyBool1                         FrontPlateFitImage;
    FbxPropertyBool1                         FrontPlateCrop;
    FbxPropertyBool1                         FrontPlateCenter;
    FbxPropertyBool1                         FrontPlateKeepRatio;
    FbxPropertyBool1                         ShowFrontplate;
    FbxPropertyDouble1                       FrontPlaneOffsetX;
    FbxPropertyDouble1                       FrontPlaneOffsetY;
    FbxPropertyDouble1                       FrontPlaneRotation;
    FbxPropertyDouble1                       FrontPlaneScaleX;
    FbxPropertyDouble1                       FrontPlaneScaleY;
    FbxPropertyFbxReference					 ForegroundTexture;
    FbxPropertyDouble1						 ForegroundOpacity;
    FbxPropertyBool1                         DisplaySafeArea;
    FbxPropertyBool1                         DisplaySafeAreaOnRender;
    FbxPropertyESafeAreaStyle                SafeAreaDisplayStyle;
    FbxPropertyDouble1                       SafeAreaAspectRatio;
    FbxPropertyBool1                         Use2DMagnifierZoom;
    FbxPropertyDouble1                       _2DMagnifierZoom;
    FbxPropertyDouble1                       _2DMagnifierX;
    FbxPropertyDouble1                       _2DMagnifierY;
    FbxPropertyEProjectionType               ProjectionType;
    FbxPropertyDouble1                       OrthoZoom;
    FbxPropertyBool1                         UseRealTimeDOFAndAA;
    FbxPropertyBool1                         UseDepthOfField;
    FbxPropertyEFocusDistanceSource          FocusSource;
    FbxPropertyDouble1                       FocusAngle;
    FbxPropertyDouble1                       FocusDistance;
    FbxPropertyBool1                         UseAntialiasing;
    FbxPropertyDouble1                       AntialiasingIntensity;
    FbxPropertyEAntialiasingMethod           AntialiasingMethod;
    FbxPropertyBool1                         UseAccumulationBuffer;
    FbxPropertyInteger1                      FrameSamplingCount;
    FbxPropertyESamplingType                 FrameSamplingType;

protected:
    virtual ~FbxCamera();
};
