# API Documentation — Perpustakaan (Library)

## Base URL

```
http://localhost:8000/api
```

## Authentication

API ini menggunakan **Laravel Sanctum** dengan Bearer Token.

### Cara mendapatkan token:
1. Register atau Login melalui endpoint yang tersedia
2. Simpan `token` dari response
3. Gunakan token di header setiap request yang membutuhkan autentikasi:

```
Authorization: Bearer {your_token}
```

---

## Error Codes

| Code | Keterangan |
|------|------------|
| 200  | Success |
| 201  | Created |
| 401  | Unauthorized — Token tidak valid atau tidak ada |
| 404  | Not Found — Resource tidak ditemukan |
| 422  | Validation Error — Data input tidak valid |
| 429  | Too Many Requests — Rate limit exceeded (max 60 req/menit) |
| 500  | Server Error |

---

## Response Format

Semua response menggunakan format konsisten:

```json
{
  "success": true,
  "message": "Deskripsi operasi",
  "data": { ... }
}
```

---

## 1. Auth Endpoints

### POST `/api/register`

Registrasi user baru.

**Headers:**
```
Accept: application/json
Content-Type: application/json
```

**Request Body:**
```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123",
  "password_confirmation": "password123"
}
```

**Response Sukses (201):**
```json
{
  "success": true,
  "message": "User registered successfully",
  "data": {
    "user": {
      "id": 1,
      "name": "John Doe",
      "email": "john@example.com",
      "created_at": "2026-05-16T07:00:00.000000Z",
      "updated_at": "2026-05-16T07:00:00.000000Z"
    },
    "token": "1|abc123def456...",
    "token_type": "Bearer"
  }
}
```

**Response Gagal (422):**
```json
{
  "success": false,
  "message": "Validation errors",
  "data": {
    "email": ["The email has already been taken."],
    "password": ["The password field confirmation does not match."]
  }
}
```

---

### POST `/api/login`

Login dan mendapatkan bearer token.

**Headers:**
```
Accept: application/json
Content-Type: application/json
```

**Request Body:**
```json
{
  "email": "john@example.com",
  "password": "password123"
}
```

**Response Sukses (200):**
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "user": {
      "id": 1,
      "name": "John Doe",
      "email": "john@example.com"
    },
    "token": "2|xyz789ghi012...",
    "token_type": "Bearer"
  }
}
```

**Response Gagal (401):**
```json
{
  "success": false,
  "message": "Invalid credentials",
  "data": null
}
```

---

### POST `/api/logout`

Logout dan revoke token saat ini.

**Headers:**
```
Accept: application/json
Authorization: Bearer {token}
```

**Response Sukses (200):**
```json
{
  "success": true,
  "message": "Logged out successfully",
  "data": null
}
```

**Response Gagal (401):**
```json
{
  "message": "Unauthenticated."
}
```

---

### GET `/api/user`

Mendapatkan data user yang sedang login.

**Headers:**
```
Accept: application/json
Authorization: Bearer {token}
```

**Response Sukses (200):**
```json
{
  "success": true,
  "message": "User data retrieved successfully",
  "data": {
    "id": 1,
    "name": "John Doe",
    "email": "john@example.com",
    "email_verified_at": null,
    "created_at": "2026-05-16T07:00:00.000000Z",
    "updated_at": "2026-05-16T07:00:00.000000Z"
  }
}
```

---

## 2. Categories Endpoints

> Semua endpoint categories memerlukan `Authorization: Bearer {token}`

### GET `/api/categories`

List semua kategori beserta jumlah buku.

**Headers:**
```
Accept: application/json
Authorization: Bearer {token}
```

**Response Sukses (200):**
```json
{
  "success": true,
  "message": "Categories retrieved successfully",
  "data": [
    {
      "id": 1,
      "name": "Fiksi",
      "description": "Buku-buku fiksi dan novel",
      "books_count": 5,
      "created_at": "2026-05-16T07:00:00.000000Z",
      "updated_at": "2026-05-16T07:00:00.000000Z"
    }
  ]
}
```

---

### POST `/api/categories`

Buat kategori baru.

**Headers:**
```
Accept: application/json
Content-Type: application/json
Authorization: Bearer {token}
```

**Request Body:**
```json
{
  "name": "Fiksi",
  "description": "Buku-buku fiksi dan novel"
}
```

**Response Sukses (201):**
```json
{
  "success": true,
  "message": "Category created successfully",
  "data": {
    "id": 1,
    "name": "Fiksi",
    "description": "Buku-buku fiksi dan novel",
    "created_at": "2026-05-16T07:00:00.000000Z",
    "updated_at": "2026-05-16T07:00:00.000000Z"
  }
}
```

**Response Gagal (422):**
```json
{
  "success": false,
  "message": "Validation errors",
  "data": {
    "name": ["The name has already been taken."]
  }
}
```

---

### GET `/api/categories/{id}`

Detail kategori beserta daftar bukunya.

**Headers:**
```
Accept: application/json
Authorization: Bearer {token}
```

**Response Sukses (200):**
```json
{
  "success": true,
  "message": "Category retrieved successfully",
  "data": {
    "id": 1,
    "name": "Fiksi",
    "description": "Buku-buku fiksi dan novel",
    "books_count": 2,
    "books": [
      {
        "id": 1,
        "title": "Laskar Pelangi",
        "description": "Novel tentang pendidikan",
        "author": "Andrea Hirata",
        "cover_image_url": "http://localhost:8000/storage/books/covers/abc123.jpg",
        "created_at": "2026-05-16T07:00:00.000000Z",
        "updated_at": "2026-05-16T07:00:00.000000Z"
      }
    ],
    "created_at": "2026-05-16T07:00:00.000000Z",
    "updated_at": "2026-05-16T07:00:00.000000Z"
  }
}
```

**Response Gagal (404):**
```json
{
  "success": false,
  "message": "Category not found",
  "data": null
}
```

---

### PUT `/api/categories/{id}`

Update kategori.

**Headers:**
```
Accept: application/json
Content-Type: application/json
Authorization: Bearer {token}
```

**Request Body:**
```json
{
  "name": "Fiksi Ilmiah",
  "description": "Buku-buku fiksi ilmiah dan sains"
}
```

**Response Sukses (200):**
```json
{
  "success": true,
  "message": "Category updated successfully",
  "data": {
    "id": 1,
    "name": "Fiksi Ilmiah",
    "description": "Buku-buku fiksi ilmiah dan sains",
    "created_at": "2026-05-16T07:00:00.000000Z",
    "updated_at": "2026-05-16T07:05:00.000000Z"
  }
}
```

---

### DELETE `/api/categories/{id}`

Hapus kategori (buku terkait juga ikut terhapus via cascade).

**Headers:**
```
Accept: application/json
Authorization: Bearer {token}
```

**Response Sukses (200):**
```json
{
  "success": true,
  "message": "Category deleted successfully",
  "data": null
}
```

---

## 3. Books Endpoints

> Semua endpoint books memerlukan `Authorization: Bearer {token}`

### GET `/api/books`

List buku dengan pagination (15 per halaman).

**Headers:**
```
Accept: application/json
Authorization: Bearer {token}
```

**Query Parameters:**
| Parameter | Tipe   | Keterangan |
|-----------|--------|------------|
| page      | integer | Nomor halaman (default: 1) |

**Response Sukses (200):**
```json
{
  "success": true,
  "message": "Books retrieved successfully",
  "data": [
    {
      "id": 1,
      "title": "Laskar Pelangi",
      "author": "Andrea Hirata",
      "cover_image_url": "http://localhost:8000/storage/books/covers/abc123.jpg",
      "category": {
        "id": 1,
        "name": "Fiksi"
      },
      "created_at": "2026-05-16T07:00:00.000000Z",
      "updated_at": "2026-05-16T07:00:00.000000Z"
    }
  ],
  "meta": {
    "current_page": 1,
    "last_page": 3,
    "per_page": 15,
    "total": 42
  }
}
```

---

### POST `/api/books`

Buat buku baru dengan upload gambar cover.

> **Catatan**: Gunakan `multipart/form-data` untuk endpoint ini karena ada upload file gambar.

**Headers:**
```
Accept: application/json
Content-Type: multipart/form-data
Authorization: Bearer {token}
```

**Request Body (form-data):**

| Field        | Tipe   | Required | Keterangan |
|-------------|--------|----------|------------|
| title       | string | Ya       | Judul buku (max 200 karakter) |
| description | string | Ya       | Deskripsi buku |
| author      | string | Ya       | Nama penulis (max 100 karakter) |
| category_id | integer| Ya       | ID kategori yang valid |
| cover_image | file   | Tidak    | Gambar cover (jpeg, png, jpg, webp, max 2MB) |

**Response Sukses (201):**
```json
{
  "success": true,
  "message": "Book created successfully",
  "data": {
    "id": 1,
    "title": "Laskar Pelangi",
    "description": "Novel tentang pendidikan di Belitung",
    "author": "Andrea Hirata",
    "cover_image_url": "http://localhost:8000/storage/books/covers/abc123.jpg",
    "category": {
      "id": 1,
      "name": "Fiksi"
    },
    "created_at": "2026-05-16T07:00:00.000000Z",
    "updated_at": "2026-05-16T07:00:00.000000Z"
  }
}
```

**Response Gagal (422):**
```json
{
  "success": false,
  "message": "Validation errors",
  "data": {
    "title": ["The title field is required."],
    "category_id": ["The selected category id is invalid."]
  }
}
```

---

### GET `/api/books/{id}`

Detail buku lengkap dengan kategori.

**Headers:**
```
Accept: application/json
Authorization: Bearer {token}
```

**Response Sukses (200):**
```json
{
  "success": true,
  "message": "Book retrieved successfully",
  "data": {
    "id": 1,
    "title": "Laskar Pelangi",
    "description": "Novel tentang pendidikan di Belitung",
    "author": "Andrea Hirata",
    "cover_image_url": "http://localhost:8000/storage/books/covers/abc123.jpg",
    "category": {
      "id": 1,
      "name": "Fiksi",
      "description": "Buku-buku fiksi dan novel"
    },
    "created_at": "2026-05-16T07:00:00.000000Z",
    "updated_at": "2026-05-16T07:00:00.000000Z"
  }
}
```

**Response Gagal (404):**
```json
{
  "success": false,
  "message": "Book not found",
  "data": null
}
```

---

### PUT/POST `/api/books/{id}`

Update buku. Jika mengirim file gambar baru, gambar lama akan dihapus.

> **Catatan**: Gunakan `multipart/form-data` dan method `POST` dengan field `_method=PUT` untuk upload file, atau gunakan `PUT` dengan `application/json` jika tidak ada upload file.

**Headers:**
```
Accept: application/json
Content-Type: multipart/form-data
Authorization: Bearer {token}
```

**Request Body (form-data):**

| Field        | Tipe   | Required | Keterangan |
|-------------|--------|----------|------------|
| _method     | string | Ya (jika POST) | Set ke "PUT" |
| title       | string | Tidak    | Judul buku (max 200 karakter) |
| description | string | Tidak    | Deskripsi buku |
| author      | string | Tidak    | Nama penulis (max 100 karakter) |
| category_id | integer| Tidak    | ID kategori yang valid |
| cover_image | file   | Tidak    | Gambar cover baru (jpeg, png, jpg, webp, max 2MB) |

**Response Sukses (200):**
```json
{
  "success": true,
  "message": "Book updated successfully",
  "data": {
    "id": 1,
    "title": "Laskar Pelangi (Edisi Revisi)",
    "description": "Novel tentang pendidikan di Belitung - edisi terbaru",
    "author": "Andrea Hirata",
    "cover_image_url": "http://localhost:8000/storage/books/covers/new_cover.jpg",
    "category": {
      "id": 1,
      "name": "Fiksi"
    },
    "created_at": "2026-05-16T07:00:00.000000Z",
    "updated_at": "2026-05-16T07:10:00.000000Z"
  }
}
```

---

### DELETE `/api/books/{id}`

Hapus buku beserta file gambar cover-nya.

**Headers:**
```
Accept: application/json
Authorization: Bearer {token}
```

**Response Sukses (200):**
```json
{
  "success": true,
  "message": "Book deleted successfully",
  "data": null
}
```

**Response Gagal (404):**
```json
{
  "success": false,
  "message": "Book not found",
  "data": null
}
```

---

## Catatan Khusus

### Upload Gambar
- Gunakan `Content-Type: multipart/form-data` untuk endpoint yang memerlukan upload file
- Format gambar yang diterima: `jpeg`, `png`, `jpg`, `webp`
- Ukuran maksimal: **2 MB** (2048 KB)
- Gambar disimpan di `storage/app/public/books/covers/`
- URL gambar dapat diakses melalui `http://localhost:8000/storage/books/covers/{filename}`

### Rate Limiting
- Semua endpoint yang memerlukan autentikasi dibatasi **60 request per menit**
- Jika melebihi batas, akan mendapat response `429 Too Many Requests`

### Pagination
- Endpoint `GET /api/books` menggunakan pagination dengan **15 item per halaman**
- Gunakan query parameter `?page=2` untuk halaman selanjutnya
- Informasi pagination tersedia di field `meta` pada response
