;; Store Verification Contract
;; Validates legitimate retail locations

(define-data-var admin principal tx-sender)

;; Map to store verified retail locations
(define-map verified-stores principal bool)

;; Error codes
(define-constant ERR-NOT-AUTHORIZED u100)
(define-constant ERR-ALREADY-VERIFIED u101)
(define-constant ERR-NOT-VERIFIED u102)

;; Check if caller is admin
(define-private (is-admin)
  (is-eq tx-sender (var-get admin)))

;; Verify a store
(define-public (verify-store (store-address principal))
  (begin
    (asserts! (is-admin) (err ERR-NOT-AUTHORIZED))
    (asserts! (is-none (map-get? verified-stores store-address)) (err ERR-ALREADY-VERIFIED))
    (map-set verified-stores store-address true)
    (ok true)))

;; Revoke store verification
(define-public (revoke-store (store-address principal))
  (begin
    (asserts! (is-admin) (err ERR-NOT-AUTHORIZED))
    (asserts! (is-some (map-get? verified-stores store-address)) (err ERR-NOT-VERIFIED))
    (map-delete verified-stores store-address)
    (ok true)))

;; Check if a store is verified
(define-read-only (is-verified (store-address principal))
  (default-to false (map-get? verified-stores store-address)))

;; Transfer admin rights
(define-public (transfer-admin (new-admin principal))
  (begin
    (asserts! (is-admin) (err ERR-NOT-AUTHORIZED))
    (var-set admin new-admin)
    (ok true)))
