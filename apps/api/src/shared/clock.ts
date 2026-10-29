export const CLOCK = Symbol('CLOCK');

/** L'heure courante, remplaçable dans les tests. */
export interface Clock {
  now(): Date;
}

export const systemClock: Clock = { now: () => new Date() };
