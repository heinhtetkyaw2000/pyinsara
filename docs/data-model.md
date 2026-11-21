# Pyinsara data model

- profiles: customer contact and delivery profile
- categories: product grouping
- products: SKU, MMK price, stock and image
- orders: customer, address, order state, totals, payment and tracking fields
- order_items: immutable product name/price/quantity snapshot per order
- payment_proofs: manual payment evidence and review state
- admin_users: owner/manager/fulfillment role membership

Order lifecycle: pending → confirmed → packing → shipped → delivered. Cancellation is available before fulfilment completion. Payment lifecycle: unpaid → pending_verification → paid (or failed/refunded).
