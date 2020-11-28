# Tap
Read / Write over NFC (for sharing small data-sets)

## Features:
- Read NFC data
- Write NFC data

## Gotchas:
- iPhone XS and later support background tag reading.
- To launch custom apps in background mode use universal links
- NDEF Record: This contains your payload value, such as a string, URL or custom data. It also contains information about that payload value, like length and type. This information is the NFCNDEFPayload within CoreNFC.
- NDEF Message: This is the data structure that holds NDEF records. There can be one or more NDEF records within an NDEF message.
- NFC is the technology that enables contactless communication between 2 devices within a certain distance (usually about 4 cm).
- **NFC card emulation** Enables NFC-enabled devices such as smartphones to act like smart cards, allowing users to perform transactions such as payment or ticketing.
- **NFC reader/writer** Enables NFC-enabled devices to read information stored on inexpensive NFC tags embedded in labels or smart posters.
- **NFC peer-to-peer** Enables two NFC-enabled devices to communicate with each other to exchange information in an adhoc fashion.

## Goal
- Ability to share small pieces of data, like netflix account details, or wifi password
- Put device in share-mode, tap other device (can be in background mode) to share account item to relevant app
- Can be used in conjunction with bluetooth to establish BT connection without pairing etc
