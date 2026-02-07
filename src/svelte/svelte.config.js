import adapter from '@sveltejs/adapter-static';

/** @type {import('@sveltejs/kit').Config} */
const config = {
  kit: {
    adapter: adapter({
      fallback: 'index.html',
      pages: '../../project/web/front',
      assets: '../../project/web/front',
    })
  }
};

export default config;
