import AppAttestation from './NativeAppAttestation';

export function multiply(a: number, b: number): Promise<number> {
  return AppAttestation.multiply(a, b);
}
