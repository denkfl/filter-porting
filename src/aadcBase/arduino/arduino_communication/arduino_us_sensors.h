/**
 *
 * ADTF Template Project Filter.
 *
 * @file
 * Copyright &copy; Audi Electronics Venture GmbH. All rights reserved
 *
 * $Author: sebastian-geissler $
 * $Date: 2018-03-26 15:21:05 +0200 (Mo, 26. Mrz 2018) $
 * $Revision: 64283 $
 *
 * @remarks
 *
 */
#ifndef _ARD_US_SENSORS_H_
#define _ARD_US_SENSORS_H_

#define CID_ARD_US_SENSOR_STREAMING_SOURCE "ArduinoUSSensors.streaming_source.adtf.cid"

//*************************************************************************************************
class cArduinoUSSensors : public adtf::streaming::cSampleStreamingSource
{
    public:
        ADTF_CLASS_ID_NAME(cArduinoUSSensors,
                            CID_ARD_US_SENSOR_STREAMING_SOURCE,
                           "Arduino Ultrasonic Sensors");

        ADTF_CLASS_DEPENDENCIES(REQUIRE_INTERFACE(adtf::services::IReferenceClock));

    private:
        property_variable<tInt64> m_nFrameDelay = 1000000;
        object_ptr<adtf::services::IReferenceClock> m_pClock;

        std::vector<tUInt8> m_oBuffer;

        cSampleWriter m_oOutputWriter;
        kernel_timer m_oTimer;

    public:
        cArduinoUSSensors();

        tResult Construct() override;
        tResult StartStreaming() override;
        tResult StopStreaming() override;

        adtf::mediadescription::cSampleCodecFactory m_outputUSSampleFactory;

    private:
        tVoid TimerFunc();
        
        tSize m_nUSFrontLeft;
};


//*************************************************************************************************
#endif // _DEMO_ARD_US_SENSORS_H_
