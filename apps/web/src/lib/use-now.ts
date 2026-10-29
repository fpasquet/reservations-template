'use client';

import { useEffect, useState } from 'react';

/** L'heure courante, mise à jour chaque minute (ligne « maintenant » du planning, créneaux passés). */
export function useNow(): Date {
  const [now, setNow] = useState(() => new Date());
  useEffect(() => {
    const timer = setInterval(() => setNow(new Date()), 60_000);
    return () => clearInterval(timer);
  }, []);
  return now;
}
