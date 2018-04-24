/**
 *
 * ADTF Template Project
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
#include <adtf_systemsdk.h>
using namespace adtf::util;
using namespace adtf::ucom;
using namespace adtf::base;
using namespace adtf::streaming;
using namespace adtf::system;

#include "arduino_us_sensors.h"

ADTF_PLUGIN("Arduino US Sensors Plugin",
    cArduinoUSSensors);

cArduinoUSSensors::cArduinoUSSensors()
{
    RegisterPropertyVariable("frame_delay", m_nFrameDelay);
}

tResult cArduinoUSSensors::Construct()
{
    RETURN_IF_FAILED(cSampleStreamingSource::Construct());

    //get the media description
    object_ptr<IStreamType> pType;
    RETURN_IF_FAILED(adtf::mediadescription::ant::create_adtf_default_stream_type_from_service("tUltrasonicStruct", pType, m_outputUSSampleFactory));

    // find the indexes of the element for faster access in the process method.
    RETURN_IF_FAILED(adtf_ddl::access_element::find_index(m_outputUSSampleFactory, "tSideLeft", m_nUSSideLeft));

    //create the pins
    RETURN_IF_FAILED(create_pin(*this, m_oOutputWriter, "Ultrasonic", pType));

    RETURN_NOERROR;
}

tResult cArduinoUSSensors::StartStreaming()
{
    RETURN_IF_FAILED(cSampleStreamingSource::StartStreaming());

    RETURN_IF_FAILED(_runtime->GetObject(m_pClock));

    m_oTimer = kernel_timer(cString(get_named_graph_object_full_name(*this) + "::generation_timer"),
        m_nFrameDelay, 0, &cArduinoUSSensors::TimerFunc, this);

    if (!m_oTimer.Stoppable())
    {
        RETURN_ERROR_DESC(ERR_UNEXPECTED, "Unable to create kernel timer");
    }

    RETURN_NOERROR;
}

tResult cArduinoUSSensors::StopStreaming()
{
    m_oTimer.Stop();
    return cSampleStreamingSource::StopStreaming();
}


tVoid cArduinoUSSensors::TimerFunc()
{

    object_ptr<ISample> pSample;

    tFloat64 fOutValue = rand();

    if IS_OK(alloc_sample(pSample, m_pClock->GetStreamTime()))
    {
        auto oCodec = m_outputUSSampleFactory.MakeCodecFor(pSample);

        if IS_OK(oCodec.SetElementValue(m_nUSSideLeft, fOutValue))
        {
            // the sample buffer lock is released in the destructor of oCodec
            m_oOutputWriter << pSample << flush << trigger;
        }
    }
}

