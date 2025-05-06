// backend2/test/query.test.js
import request from 'supertest';
import app from '../index.js';  // comprueba que aquí sea la ruta correcta a tu Express app

describe('GET /api/query', () => {
  it('debe devolver 200 y el cuerpo esperado', async () => {
    const res = await request(app)
      .get('/api/query')
      .query({ q: 'jenkins-test' });

    expect(res.status).toBe(200);
    expect(res.body).toEqual({ resultado: 'Recibido: jenkins-test' });
  });
});
