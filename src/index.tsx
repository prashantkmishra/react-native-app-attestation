import AppAttestation from './NativeAppAttestation';
import type { AttestationResult } from './types';

export async function attest(
  nonce: string,
  cloudProjectNumber?: string
): Promise<AttestationResult> {
  return AppAttestation.attest(nonce, cloudProjectNumber);
}
