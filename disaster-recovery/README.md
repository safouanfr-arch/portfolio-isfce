# DocuSafe Services disaster recovery plan

Academic case study by Safouan Tassi, ISFCE systems administration coursework, 2025–2026. DocuSafe Services is a fictional small business that stores and serves documents for medical and legal practices. The original work assessed how a ransomware incident could interrupt access to the document portal.

## Business impact and recovery scope

| Service | Role in the case study | What to verify during recovery |
| --- | --- | --- |
| Web portal | Customers submit and consult documents. | Authorized test users can sign in, upload and retrieve a test document. |
| Database | Holds customer and document metadata. | The restored records are consistent with the restored file set. |
| File server | Stores customer documents. | Sample files are readable and permissions match the intended users. |

An outage can interrupt client work, cause data loss, and create financial and reputational impact. The original plan identifies the three systems as critical. It does not assign numeric recovery time or recovery point objectives.

## Measures proposed in the original work

1. **Normal operation.** Back up data regularly, patch systems, maintain endpoint and network protection, and train staff to recognize phishing.
2. **Degraded operation.** Recover priority documents from backups or use a standby system to maintain essential access. The original also considered temporary manual handling.
3. **Disaster recovery.** Identify the incident, isolate affected servers and notify IT. Rebuild affected systems, restore backup data, validate the service and communicate restoration to customers.

## Portfolio review notes

Before using this scenario in an exercise, define who declares a disaster, approves a clean recovery point, signs off service validation and communicates with customers. Set RTO and RPO by business service, and test both technical restoration and communications. Store an isolated or immutable backup copy and verify it separately from routine backups.

The original discussed email as a possible degraded-mode channel. For medical or legal records, only use an approved channel with access controls, encryption and traceability. Record the decision and the scope of a failed or delayed fallback.

The source is a planning exercise. No recovery exercise, elapsed time, restoration result or customer notification is presented as having occurred.

## Provenance

Based on the local two-page submission `ISFCE/admin/DRP - Tassi Safouan.pdf`, credited to Safouan Tassi. Page 1 covers context, critical services and impact. Page 2 covers prevention, degraded operation and recovery. This case study paraphrases the submission and identifies later review notes separately.

Source SHA-256 `e6dddc58ff38ab0d6d4433e2f31aa463dfacc7a84c38b566ab0d64364389b2bc`.
