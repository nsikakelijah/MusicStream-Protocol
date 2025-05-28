;; MusicStream Protocol - Decentralized music streaming with artist royalties
(define-non-fungible-token music-track uint)

;; Storage
(define-map track-registry uint {creator: principal, title: (string-utf8 64), genre: (string-utf8 256), audio-hash: (string-utf8 256), stream-cost: uint})
(define-data-var track-counter uint u0)

;; Error codes
(define-constant err-unauthorized-access (err u200))
(define-constant err-track-not-exists (err u201))
(define-constant err-payment-failed (err u202))
(define-constant err-empty-title (err u203))
(define-constant err-empty-genre (err u204))
(define-constant err-invalid-hash (err u205))
(define-constant err-zero-cost (err u206))
(define-constant err-invalid-track (err u207))

;; Register a new music track
(define-public (register-track (title (string-utf8 64)) (genre (string-utf8 256)) (audio-hash (string-utf8 256)) (stream-cost uint))
  (begin
    ;; Input validation
    (asserts! (> (len title) u0) err-empty-title)
    (asserts! (> (len genre) u0) err-empty-genre)
    (asserts! (> (len audio-hash) u0) err-invalid-hash)
    (asserts! (> stream-cost u0) err-zero-cost)
    
    (let
      ((track-id (var-get track-counter))
       (creator tx-sender))
      
      ;; Mint the track NFT
      (try! (nft-mint? music-track track-id creator))
      
      ;; Store track information
      (map-set track-registry track-id {creator: creator, title: title, genre: genre, audio-hash: audio-hash, stream-cost: stream-cost})
      
      ;; Increment counter
      (var-set track-counter (+ track-id u1))
      
      (ok track-id))))

;; Stream a music track (pay per stream)
(define-public (stream-track (track-id uint))
  (begin
    ;; Validate track exists
    (asserts! (< track-id (var-get track-counter)) err-invalid-track)
    
    (let
      ((track-info (unwrap! (map-get? track-registry track-id) err-track-not-exists))
       (cost (get stream-cost track-info))
       (creator (get creator track-info))
       (owner (unwrap! (nft-get-owner? music-track track-id) err-track-not-exists)))
      
      ;; Check listener has enough funds
      (asserts! (>= (stx-get-balance tx-sender) cost) err-payment-failed)
      
      ;; Pay streaming fee to creator
      (try! (stx-transfer? cost tx-sender creator))
      
      ;; Transfer track ownership to listener
      (try! (nft-transfer? music-track track-id owner tx-sender))
      
      (ok true))))

;; Get track information
(define-read-only (get-track-info (track-id uint))
  (map-get? track-registry track-id))

;; Verify track ownership
(define-read-only (verify-ownership (track-id uint) (listener principal))
  (is-eq (some listener) (nft-get-owner? music-track track-id)))

;; Get track owner
(define-read-only (get-track-owner (track-id uint))
  (nft-get-owner? music-track track-id))
