const express = require("express");
const cors = require("cors");
const axios = require("axios");

const app = express();
const PORT = 3001;

// Enable CORS for all routes
app.use(cors());
app.use(express.json());

// Spotify API credentials (should be in environment variables in production)
const SPOTIFY_CLIENT_ID = "b8e20a7d60dc4c6e9ee2b70c5aa7e797";
const SPOTIFY_CLIENT_SECRET = "2c10094554604df6a874c0525d28788c";
const SPOTIFY_TOKEN_URL = "https://accounts.spotify.com/api/token";
const SPOTIFY_API_BASE = "https://api.spotify.com/v1";

// Cache for access token
let cachedToken = null;
let tokenExpiry = null;

// Get Spotify access token
async function getAccessToken() {
  // Check if cached token is still valid
  if (cachedToken && tokenExpiry && Date.now() < tokenExpiry) {
    console.log("Using cached token");
    return cachedToken;
  }

  try {
    console.log("Requesting new Spotify token...");
    const credentials = Buffer.from(
      `${SPOTIFY_CLIENT_ID}:${SPOTIFY_CLIENT_SECRET}`
    ).toString("base64");
    const response = await axios.post(
      SPOTIFY_TOKEN_URL,
      "grant_type=client_credentials",
      {
        headers: {
          Authorization: `Basic ${credentials}`,
          "Content-Type": "application/x-www-form-urlencoded",
        },
      }
    );

    cachedToken = response.data.access_token;
    const expiresIn = response.data.expires_in || 3600;
    tokenExpiry = Date.now() + (expiresIn - 60) * 1000; // Refresh 1 minute early

    console.log("Token obtained successfully");
    return cachedToken;
  } catch (error) {
    console.error(
      "Error getting Spotify token:",
      error.response?.data || error.message
    );
    throw error;
  }
}

// Proxy endpoint for recommendations
app.get("/api/recommendations", async (req, res) => {
  try {
    console.log("Received recommendations request:", req.query);
    const token = await getAccessToken();
    const queryParams = new URLSearchParams(req.query).toString();
    const spotifyUrl = `${SPOTIFY_API_BASE}/recommendations?${queryParams}`;
    console.log("Calling Spotify API:", spotifyUrl);

    const response = await axios.get(spotifyUrl, {
      headers: {
        Authorization: `Bearer ${token}`,
        Accept: "application/json",
      },
    });

    console.log("Spotify API response:", response.status);
    res.json(response.data);
  } catch (error) {
    console.error("Error fetching recommendations:");
    console.error("  Status:", error.response?.status);
    console.error("  Data:", error.response?.data);
    console.error("  Message:", error.message);
    res.status(error.response?.status || 500).json({
      error: error.response?.data || { message: error.message },
    });
  }
});

// Proxy endpoint for search
app.get("/api/search", async (req, res) => {
  try {
    const token = await getAccessToken();
    const queryParams = new URLSearchParams(req.query).toString();

    const response = await axios.get(
      `${SPOTIFY_API_BASE}/search?${queryParams}`,
      {
        headers: {
          Authorization: `Bearer ${token}`,
          Accept: "application/json",
        },
      }
    );

    res.json(response.data);
  } catch (error) {
    console.error("Error searching:", error.response?.data || error.message);
    res.status(error.response?.status || 500).json({
      error: error.response?.data || { message: error.message },
    });
  }
});

// Proxy endpoint for new releases
app.get("/api/browse/new-releases", async (req, res) => {
  try {
    const token = await getAccessToken();
    const queryParams = new URLSearchParams(req.query).toString();

    const response = await axios.get(
      `${SPOTIFY_API_BASE}/browse/new-releases?${queryParams}`,
      {
        headers: {
          Authorization: `Bearer ${token}`,
          Accept: "application/json",
        },
      }
    );

    res.json(response.data);
  } catch (error) {
    console.error(
      "Error fetching new releases:",
      error.response?.data || error.message
    );
    res.status(error.response?.status || 500).json({
      error: error.response?.data || { message: error.message },
    });
  }
});

// Proxy endpoint for artist top tracks
app.get("/api/artists/:artistId/top-tracks", async (req, res) => {
  try {
    const token = await getAccessToken();
    const { artistId } = req.params;
    const queryParams = new URLSearchParams(req.query).toString();

    const response = await axios.get(
      `${SPOTIFY_API_BASE}/artists/${artistId}/top-tracks?${queryParams}`,
      {
        headers: {
          Authorization: `Bearer ${token}`,
          Accept: "application/json",
        },
      }
    );

    res.json(response.data);
  } catch (error) {
    console.error(
      "Error fetching artist top tracks:",
      error.response?.data || error.message
    );
    res.status(error.response?.status || 500).json({
      error: error.response?.data || { message: error.message },
    });
  }
});

// Proxy endpoint for artist profile
app.get("/api/artists/:artistId", async (req, res) => {
  try {
    const token = await getAccessToken();
    const { artistId } = req.params;

    const response = await axios.get(
      `${SPOTIFY_API_BASE}/artists/${artistId}`,
      {
        headers: {
          Authorization: `Bearer ${token}`,
          Accept: "application/json",
        },
      }
    );

    res.json(response.data);
  } catch (error) {
    console.error(
      "Error fetching artist profile:",
      error.response?.data || error.message
    );
    res.status(error.response?.status || 500).json({
      error: error.response?.data || { message: error.message },
    });
  }
});

// Health check endpoint
app.get("/health", (req, res) => {
  res.json({
    status: "ok",
    message: "Spotify proxy server is running",
  });
});

app.listen(PORT, () => {
  console.log(`Spotify Proxy Server running on http://localhost:${PORT}`);
  console.log(`Ready to proxy Spotify API requests`);
});
