# Diagnostic Notes: Quest Loading Flow

Tracking the end-to-end data flow to identify where "Quest Unavailable" originates.

## 1. Firestore Structure Requirement
- **Collection**: `quests`
- **Document**: `{gameSubtypeName}` (e.g., `audioFillBlanks`)
- **Sub-collection**: `levels`
- **Document**: `{levelNumber}` (e.g., `1`)
- **Fields**:
  - `id`: `level_{N}`
  - `levelNumber`: `{N}`
  - `quests`: `Array<Map>` (Contains the actual quest items)

## 2. Model Mapping (ListeningQuestModel)
- `transcript`: Mapped from `transcript` OR `textToSpeak`.
- `missingWord`: Required for `audioFillBlanks`.
- `interactionType`: Must match `InteractionType` enum (e.g., `writing`).
- `difficulty`: Defaults to 1 if missing.

## 3. Data Source Logic
- Now throws detailed `ServerException(message)` instead of generic failure.
- Removed legacy path fallbacks to ensure we are testing the **Global Alignment** path.

## 4. Bloc Handling
- `ListeningBloc` listens for `FetchListeningQuests`.
- If state is `ListeningError`, the `message` field contains the **exact** exception from Firestore or JSON parsing.

## 5. Verification Checklist
- [ ] Run "PUSH ALL ASSETS" in Admin Dashboard.
- [ ] Check console/status logs for "Found X sections".
- [ ] Open game screen and check if error message is specific (e.g., "Field 'xpReward' is not an int").
