# MusicStream Protocol

MusicStream Protocol is a revolutionary decentralized music streaming platform built on Stacks blockchain, enabling direct artist-to-listener monetization through blockchain technology.

## Features

- **Decentralized Music Distribution**: Artists upload and distribute music without intermediaries
- **Pay-Per-Stream Model**: Listeners pay directly to artists for each stream
- **Blockchain Ownership**: Transparent ownership tracking of music tracks
- **Creator Royalties**: Direct payments to music creators with every stream

## Smart Contract Functions

### Music Management
- `register-track`: Upload and register a new music track with metadata
- `stream-track`: Stream music and automatically pay the creator
- `get-track-info`: Retrieve metadata about a specific track
- `get-track-owner`: Check current owner of a music track
- `verify-ownership`: Confirm if an address owns streaming rights

## Getting Started

1. Clone this repository
2. Install [Clarinet](https://github.com/hirosystems/clarinet)
3. Run `clarinet check` to validate contracts
4. Deploy using Clarinet or Stacks CLI

## For Musicians

Musicians can register their tracks by providing:
- Track title and genre
- Audio file hash (IPFS recommended)
- Streaming cost in STX

## For Listeners

Listeners can stream music directly, with payments automatically sent to creators.