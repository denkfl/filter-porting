// This is a generated file, changes to it may be overwritten in the future.
#ifndef MQTT_MESSAGE_HEADER
#define MQTT_MESSAGE_HEADER

#pragma pack(push,1)
typedef struct
{
    tChar strTopic[256];
    tUInt32 ui32Length;
    tUInt8* aPayload;
} tMQTTMessage;
#pragma pack(pop)

// The following types are assumed to be known:
// tChar
// tUInt32
// tUInt8

#endif