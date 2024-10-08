mkdir build
cd build

cmake %CMAKE_ARGS% ^
    -G "Ninja" ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DBUILD_SHARED_LIBS=ON ^
    -DENABLE_icubmod_cartesiancontrollerserver:BOOL=ON ^
    -DENABLE_icubmod_cartesiancontrollerclient:BOOL=ON ^
    -DENABLE_icubmod_gazecontrollerclient:BOOL=ON ^
    -DENABLE_icubmod_skinWrapper:BOOL=ON ^
    -DENABLE_icubmod_dragonfly2:BOOL=OFF ^
    -DENABLE_icubmod_sharedcan:BOOL=ON ^
    -DENABLE_icubmod_bcbBattery:BOOL=ON ^
    -DENABLE_icubmod_canmotioncontrol:BOOL=ON ^
    -DENABLE_icubmod_canBusAnalogSensor:BOOL=ON ^
    -DENABLE_icubmod_canBusInertialMTB:BOOL=ON ^
    -DENABLE_icubmod_canBusSkin:BOOL=ON ^
    -DENABLE_icubmod_canBusFtSensor:BOOL=ON ^
    -DENABLE_icubmod_canBusVirtualAnalogSensor:BOOL=ON ^
    -DENABLE_icubmod_cfw2can:BOOL=OFF ^
    -DENABLE_icubmod_ecan:BOOL=OFF ^
    -DENABLE_icubmod_embObjBattery:BOOL=ON ^
    -DENABLE_icubmod_embObjFTsensor:BOOL=ON ^
    -DENABLE_icubmod_embObjMultipleFTsensors:BOOL=ON ^
    -DENABLE_icubmod_embObjIMU:BOOL=ON ^
    -DENABLE_icubmod_embObjMais:BOOL=ON ^
    -DENABLE_icubmod_embObjMotionControl:BOOL=ON ^
    -DENABLE_icubmod_embObjSkin:BOOL=ON ^
    -DENABLE_icubmod_parametricCalibrator:BOOL=ON ^
    -DENABLE_icubmod_parametricCalibratorEth:BOOL=ON ^
    -DENABLE_icubmod_embObjPOS:BOOL=ON ^
    -DENABLE_icubmod_xsensmtx:BOOL=OFF ^
    -DENABLE_icubmod_socketcan:BOOL=OFF ^
    -DICUB_USE_icub_firmware_shared:BOOL=ON ^
    -DICUB_COMPILE_BINDINGS:BOOL=OFF ^
    %SRC_DIR%
if errorlevel 1 exit 1

:: Build.
cmake --build . --config Release
if errorlevel 1 exit 1

:: Install.
cmake --build . --config Release --target install
if errorlevel 1 exit 1

setlocal EnableDelayedExpansion
:: Generate and copy the [de]activate scripts to %PREFIX%\etc\conda\[de]activate.d.
:: This will allow them to be run on environment activation.
for %%F in (activate deactivate) DO (
    multisheller %RECIPE_DIR%\%%F.msh --output .\%%F

    if not exist %PREFIX%\etc\conda\%%F.d mkdir %PREFIX%\etc\conda\%%F.d
    copy %%F.bat %PREFIX%\etc\conda\%%F.d\%PKG_NAME%_%%F.bat
    if %errorlevel% neq 0 exit /b %errorlevel%

    copy %%F.sh %PREFIX%\etc\conda\%%F.d\%PKG_NAME%_%%F.sh
    if %errorlevel% neq 0 exit /b %errorlevel%

    copy %%F.bash %PREFIX%\etc\conda\%%F.d\%PKG_NAME%_%%F.bash
    if %errorlevel% neq 0 exit /b %errorlevel%

    copy %%F.ps1 %PREFIX%\etc\conda\%%F.d\%PKG_NAME%_%%F.ps1
    if %errorlevel% neq 0 exit /b %errorlevel%

    copy %%F.xsh %PREFIX%\etc\conda\%%F.d\%PKG_NAME%_%%F.xsh
    if %errorlevel% neq 0 exit /b %errorlevel%

    copy %%F.zsh %PREFIX%\etc\conda\%%F.d\%PKG_NAME%_%%F.zsh
    if %errorlevel% neq 0 exit /b %errorlevel%
)
