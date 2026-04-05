import { TurboModuleRegistry, type TurboModule } from 'react-native';
import type { AttestationResult } from './types';

export interface Spec extends TurboModule {
  attest(
    nonce: string,
    cloudProjectNumber?: string
  ): Promise<AttestationResult>;
}

export default TurboModuleRegistry.getEnforcing<Spec>('AppAttestation');
