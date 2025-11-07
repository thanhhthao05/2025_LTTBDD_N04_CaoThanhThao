const axios = require('axios');

async function testProxy() {
  try {
    console.log('Testing proxy server...\n');

    // Test 1: Health check
    console.log('Testing health endpoint...');
    const healthResponse = await axios.get('http://localhost:3001/health');
    console.log('Health check:', healthResponse.data);
    console.log('');

    // Test 2: Recommendations with single genre
    console.log('Testing recommendations with single genre (pop)...');
    try {
      const recResponse = await axios.get('http://localhost:3001/api/recommendations', {
        params: {
          limit: 5,
          market: 'US',
          seed_genres: 'pop',
        },
      });
      console.log('Recommendations received:', recResponse.data.tracks?.length || 0, 'tracks');
      if (recResponse.data.tracks && recResponse.data.tracks.length > 0) {
        console.log('   First track:', recResponse.data.tracks[0].name);
      }
    } catch (error) {
      console.error('Recommendations error:', error.response?.status, error.response?.data);
    }
    console.log('');

    // Test 3: Recommendations with multiple genres
    console.log('Testing recommendations with multiple genres (pop,dance,edm)...');
    try {
      const recResponse2 = await axios.get('http://localhost:3001/api/recommendations', {
        params: {
          limit: 5,
          market: 'US',
          seed_genres: 'pop,dance,edm',
        },
      });
      console.log('Recommendations received:', recResponse2.data.tracks?.length || 0, 'tracks');
    } catch (error) {
      console.error('Recommendations error:', error.response?.status, error.response?.data);
    }
    console.log('');

    // Test 4: Search
    console.log('Testing search...');
    try {
      const searchResponse = await axios.get('http://localhost:3001/api/search', {
        params: {
          q: 'pop',
          type: 'track',
          limit: 5,
        },
      });
      console.log('Search received:', searchResponse.data.tracks?.items?.length || 0, 'tracks');
    } catch (error) {
      console.error('Search error:', error.response?.status, error.response?.data);
    }

  } catch (error) {
    console.error('Test failed:', error.message);
    if (error.code === 'ECONNREFUSED') {
      console.error('   Make sure the proxy server is running: npm start');
    }
  }
}

testProxy();

