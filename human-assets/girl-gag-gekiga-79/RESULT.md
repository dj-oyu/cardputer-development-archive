# v79: sudden deadpan gekiga, human character only
Source: combined v78 SHA 61f1f78cd004c922e0f0ad2833bb1a5d08da6dd38156d51dc548863b0283ecb8.
Output: girl-expressions-gekiga-v79.blend SHA cf91db8dea5f680dfb07cf349165bd84717bff13a853bcd40be4dad56a91bb20.
The only newly used texture is face-gekiga.png SHA 20e3ff7bc8a3390a7d256f55925ec231e15bbf67e7b62f962df2cd4e8197d2bc.

Set the existing armature's Face Expression to 3. Compared two strength levels and selected B. Thick, downward-inward angular brows and sharply narrowed warm amber eyes read as exaggeratedly serious, aided by separate short angular cheek shadows and a firm closed mouth. There is no across-face stripe, no monochrome face wash, and no changes to the cloud. Neck, geometry, bones, UV, action curves and emote drivers remain as before. The previous dot-eye epsilon was replaced only on this human character. All historical actions are retained on reopening (six previously orphaned donor actions marked retained to stop Blender dropping them).

Exact rendered legacy equality: neutral, blink, smile, worried, surprised, sleepy at 240×135 front + quarter (12 pairs), and sweat / confusion / anger with neutral face at front (3 pairs). Gekiga+ sweat / anger visibly and numerically tested on both views. Reopen also verifies comic flags/presented transform tables and face-link identity. No Cardputer runtime claim.

Use draw79.py with assets/neutral.png (same packed v78 neutral PNG), then run apply79.py on the exact combined v78 source. verify79.py checks preserved assets, switches and mesh/action integrity, and render79.py/package79.py reproduce selected native proof. Main comparison gekiga-expressions-native-final.png; A/B gekiga-native-240x135-ab.png, 4x inspection explicitly enlarged only. GIF alternates static neutral and gekiga; it is not a newly authored animation.
