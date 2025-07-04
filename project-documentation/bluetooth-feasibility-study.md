# EveShield – Bluetooth Mesh Feasibility Study

This document assesses the practicality of using Bluetooth mesh networking (e.g., via Bridgefy or Nearby API) as part of EveShield’s offline communication layer.

---

## 🔍 Bluetooth Mesh Reality Check

| Concern                           | Reality                                                                          |
| --------------------------------- | -------------------------------------------------------------------------------- |
| Bluetooth is often off            | ✅ Most users, especially in EveShield's target market, keep Bluetooth disabled. |
| Requires app running nearby       | ✅ Other users must have the app open or in background.                          |
| Mesh needs density                | ✅ Works best with large, active, and local user base.                           |
| Battery optimizations can kill it | ✅ Android may terminate background services unless explicitly whitelisted.      |
| Range limitations                 | ✅ Bluetooth typically covers only 10–30 meters.                                 |

---

## 🔄 How Mesh Messaging Works (Bridgefy-style)

Mesh relies on relays:

```
[User A] --BT--> [User B] --BT--> [User C with internet]
```

If no relays exist (no nearby users with Bluetooth + EveShield), the message fails.

---

## ✅ Feasibility Summary

| Criterion                          | Bluetooth Mesh (P2P)              |
| ---------------------------------- | --------------------------------- |
| Works without internet             | ✅                                |
| Works without cell network         | ✅                                |
| Works if Bluetooth is off          | ❌                                |
| Works if no nearby users exist     | ❌                                |
| Needs large user base to be useful | ✅ (but problematic at MVP stage) |

---

## ✅ Recommendations

- **Use Bluetooth as a fallback**, not the main channel.
- **Educate users** to keep Bluetooth on, similar to COVID apps.
- **Primary delivery** should be:
  - USSD (feature phones)
  - SMS or internet (Android)
  - GPS (when available)

---

## ❌ Not Recommended: Central Bluetooth Broadcasting

- Bluetooth has short range (10–30m)
- Central broadcasting would require BLE towers or mesh nodes
- Not scalable or cost-effective for MVP

---

## 🧠 Final Word

Bluetooth mesh is **not reliable enough** for life-critical alerts in EveShield’s MVP stage. It should be seen as an **auxiliary feature**, not a core delivery method.

Focus on **USSD, SMS, and GPS**, and revisit mesh networking only if your active user base becomes large and dense.
