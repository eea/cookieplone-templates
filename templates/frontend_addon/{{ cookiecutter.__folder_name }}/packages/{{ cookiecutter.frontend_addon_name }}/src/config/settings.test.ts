import { describe, it, expect } from 'vitest';
import install from './settings';

describe('settings', () => {
  it('returns the config unchanged', () => {
    const config = {} as any;
    const result = install(config);
    expect(result).toBe(config);
  });
});
