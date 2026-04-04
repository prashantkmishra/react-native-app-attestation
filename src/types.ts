export type AttestationResult = {
  platform: 'android' | 'ios';
  token: string;
  keyId?: string;
};
