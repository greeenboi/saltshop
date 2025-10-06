# SaltShop

An Ecommerce Platform heavily inspired by the shopify way of development.

---

## Architectural Diagrams

<img width="1087" height="1280" alt="image" src="https://github.com/user-attachments/assets/2e9e2e6c-8c27-4f33-b620-0e59cc7225f4" />

<img width="1087" height="1280" alt="image" src="https://github.com/user-attachments/assets/fa29017c-947e-4f04-a6de-3d644992d8cf" />

<img width="948" height="1280" alt="image" src="https://github.com/user-attachments/assets/6a80f7a5-03bb-451a-9951-96db72c59a0e" />

```mermaid
classDiagram
class User {
+Integer id
+String email
+String encrypted_password
+Role role
+DateTime created_at
+DateTime updated_at
+toggle_role() : void
+promote_to_admin() : void
+demote_to_customer() : void
+is_admin() : boolean
+is_customer() : boolean
}
User "1" --> "*" Order : has_many
class Role {
<<enumeration>>
+customer
+admin
}
User --> Role

stateDiagram-v2
[*] --> customer
customer : role = customer
admin : role = admin
customer --> admin : promote / toggle_role()
admin --> customer : demote / toggle_role()
customer --> customer : no-op
admin --> admin : no-op
```

---

## Requirements

1) if windows wsl2 (preferably ubuntu)
2) ruby 3.3.6
3) postgres 17 support

---





