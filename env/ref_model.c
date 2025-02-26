#include <openssl/aes.h>
#include <stdint.h>
#include <string.h>

#include "svdpi.h"

void aes_encrypt_dpi(const svOpenArrayHandle plaintext, const svOpenArrayHandle key, svOpenArrayHandle ciphertext)
{
    AES_KEY enc_key;
    AES_set_encrypt_key((uint8_t *)svGetArrayPtr(key), 128, &enc_key);
    AES_encrypt((uint8_t *)svGetArrayPtr(plaintext), (uint8_t *)svGetArrayPtr(ciphertext), &enc_key);
}

void aes_decrypt_dpi(const svOpenArrayHandle ciphertext, const svOpenArrayHandle key, svOpenArrayHandle plaintext)
{
    AES_KEY dec_key;
    AES_set_decrypt_key((uint8_t *)svGetArrayPtr(key), 128, &dec_key);
    AES_decrypt((uint8_t *)svGetArrayPtr(ciphertext), (uint8_t *)svGetArrayPtr(plaintext), &dec_key);
}
