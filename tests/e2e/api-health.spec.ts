import { expect, test } from '@playwright/test'

const apiBaseUrl = process.env.PLAYWRIGHT_API_URL?.trim() || 'https://api-production-ab72.up.railway.app'

test.describe('api smoke', () => {
  test('health endpoint is up', async ({ request }) => {
    const response = await request.get(`${apiBaseUrl}/health`)

    expect(response.ok()).toBeTruthy()
    expect(response.status()).toBe(200)
    await expect(response.json()).resolves.toEqual({ ok: true })
  })

  test('openapi endpoint returns schema metadata', async ({ request }) => {
    const response = await request.get(`${apiBaseUrl}/openapi.json`)

    expect(response.ok()).toBeTruthy()
    expect(response.status()).toBe(200)

    const body = await response.json()
    expect(body).toHaveProperty('openapi')
    expect(body).toHaveProperty('info')
  })
})
