# Spotify Proxy Server

Backend proxy server để tránh CORS issues khi gọi Spotify API từ Flutter Web.

## Cài đặt

1. Cài đặt Node.js (nếu chưa có): https://nodejs.org/

2. Cài đặt dependencies:
```bash
npm install
```

## Chạy server

```bash
npm start
```

Server sẽ chạy tại `http://localhost:3001`

## API Endpoints

- `GET /api/recommendations` - Lấy recommendations
- `GET /api/search` - Tìm kiếm tracks
- `GET /api/browse/new-releases` - Lấy new releases
- `GET /api/artists/:artistId` - Lấy artist profile
- `GET /api/artists/:artistId/top-tracks` - Lấy top tracks của artist
- `GET /health` - Health check

## Lưu ý

- Server này chỉ dùng cho development
- Trong production, nên deploy lên server riêng và cấu hình CORS phù hợp
- Client secret được lưu trong code, nên bảo mật tốt hơn trong production

