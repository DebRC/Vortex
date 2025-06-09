// SPDX-License-Identifier: GPL-3.0
/*
    Copyright 2021 0KIMS association.

    This file is generated with [snarkJS](https://github.com/iden3/snarkjs).

    snarkJS is a free software: you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    snarkJS is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
    or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public
    License for more details.

    You should have received a copy of the GNU General Public License
    along with snarkJS. If not, see <https://www.gnu.org/licenses/>.
*/

pragma solidity >=0.7.0 <0.9.0;

contract Groth16Verifier {
    // Scalar field size
    uint256 constant r    = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
    // Base field size
    uint256 constant q   = 21888242871839275222246405745257275088696311157297823662689037894645226208583;

    // Verification Key data
    uint256 constant alphax  = 17804439093089442903016648700171928890472028512115807391846206179019664340159;
    uint256 constant alphay  = 2439163292070361801673567458549216727889789983823042778772843047245100883915;
    uint256 constant betax1  = 21821081946971927875403587995118910676840876057919812143607200701759711511781;
    uint256 constant betax2  = 10738391446383323758523991580430160033390523322272888201740576839105981212354;
    uint256 constant betay1  = 20786730584628287358406780123310611029299953018462545067840735685136360343068;
    uint256 constant betay2  = 10622617042804946187584054165314443133034745592865064525317123680518129270828;
    uint256 constant gammax1 = 11559732032986387107991004021392285783925812861821192530917403151452391805634;
    uint256 constant gammax2 = 10857046999023057135944570762232829481370756359578518086990519993285655852781;
    uint256 constant gammay1 = 4082367875863433681332203403145435568316851327593401208105741076214120093531;
    uint256 constant gammay2 = 8495653923123431417604973247489272438418190587263600148770280649306958101930;
    uint256 constant deltax1 = 9299539481759584486488022991344040588730026117571368672926827394904537022943;
    uint256 constant deltax2 = 16490843201956102439791854949974348219418457398397263005713497698769174371446;
    uint256 constant deltay1 = 3156297607296935449967486451710592397247251309121288206859697599332124675001;
    uint256 constant deltay2 = 20817477894003611931903829742757546041036446695229985780266126949854728620068;

    
    uint256 constant IC0x = 5545483804100898451830001454196306565634213652761179210994908504837370383736;
    uint256 constant IC0y = 19719122986256087409020638487162046357898908656000476147109901480100403540473;
    
    uint256 constant IC1x = 3730119853499761864890530950468236811701097016491142201901715151809387024995;
    uint256 constant IC1y = 17328282529614658565758369640633184821753346267551589141291990856366511895125;
    
    uint256 constant IC2x = 2920493686744190418125882160953078509645779300662406772176453003196273011175;
    uint256 constant IC2y = 656253728635095750147358633772373484365253999808834539333236863602530982653;
    
    uint256 constant IC3x = 10830403296466572088330745785066811541760389282465649699458227656568416416270;
    uint256 constant IC3y = 19336013454801579385248835850306965400200127862582867840225524402066255010445;
    
    uint256 constant IC4x = 5120394036775397332605756630197126974027115002546171106357935380619333133620;
    uint256 constant IC4y = 8227370977770305127655897749131784082258625741965014361361174963613306805901;
    
    uint256 constant IC5x = 11319394604722012660874351301674328363382664112446497237595945623236386434298;
    uint256 constant IC5y = 420244237749310850071547875817623004989623827759187046651967094062073402440;
    
    uint256 constant IC6x = 17137839129686906573231905352774118137606775408815398970332026442499422939126;
    uint256 constant IC6y = 9878439569103983480360877032983516515342744252504469490737301639779885312136;
    
    uint256 constant IC7x = 15352057464930207149595810924733495878193717005017273440671007990847072859235;
    uint256 constant IC7y = 4326939839388728768164791641365253584997551472346816234759721387556818177733;
    
    uint256 constant IC8x = 918547988979747358761676791829849452914416324495515640313547673934612437820;
    uint256 constant IC8y = 654978308296832645977912200332512934216724527517693450351947969447819952069;
    
    uint256 constant IC9x = 2052479434432302554549649256594679500890198630412534466076267579542030835766;
    uint256 constant IC9y = 21577919176635262131189019158516429657223807416053316006377448939244239523031;
    
    uint256 constant IC10x = 2371887066160804576301257603219589897212930869226962637461840877842934514766;
    uint256 constant IC10y = 5608172860341127350071569058225645501107276412189483018197185132862720331502;
    
    uint256 constant IC11x = 16838569963163706192790029536785571654064726265902870815739750303098727439025;
    uint256 constant IC11y = 18074959043137253954423464124156217796771640943534717387205294204288552827156;
    
    uint256 constant IC12x = 14158843834187279663457505090296691138428554024097641144554757702661497513939;
    uint256 constant IC12y = 10488353604739687472497608822392354796117077902242267017036217312668354402084;
    
    uint256 constant IC13x = 8015691086446112194026664562014471891321686565010539610780048501257220522176;
    uint256 constant IC13y = 2568201312131268757588330287651850753794770605600959590384154171572235378791;
    
    uint256 constant IC14x = 13433138041157190988108226327541418841501754977608372816540419985146580997421;
    uint256 constant IC14y = 6332003357665036217531765224754493859476901721320121554330163542743101129912;
    
    uint256 constant IC15x = 18401521297780746734708055789548087398661490306343439970287692377871415337612;
    uint256 constant IC15y = 21393402267527735908277277909969968232317085238985679659047554676738793244932;
    
    uint256 constant IC16x = 19724236344942954058844995584000005638752125437784304227356952540955415709610;
    uint256 constant IC16y = 12078945749783493632771746465296801367638236154920397927345706173651130658044;
    
    uint256 constant IC17x = 16099173598690458179076877583672716918374767908556505493068439518790051963135;
    uint256 constant IC17y = 1584647099531465009140048981913435414829571673884002702920985237444659771392;
    
    uint256 constant IC18x = 2668816603662497131174633288899128779656632307232420643049534730959778281300;
    uint256 constant IC18y = 7582903247628995243544990722244255885569455076577639499694006157832886013259;
    
    uint256 constant IC19x = 3705101520006440877334407406023691641207777864284810838686810888512330651600;
    uint256 constant IC19y = 6817718099522101910717359478526965919314965960058132698241440848078889385950;
    
    uint256 constant IC20x = 13253649065692732834079370057392612142744077845969294005171584821831052203895;
    uint256 constant IC20y = 11489228585244326751232595166364377896896199376821603611313471877159025563268;
    
    uint256 constant IC21x = 5173894227448137247383938740658516797062577724099786225401420707873352335860;
    uint256 constant IC21y = 11951957700549222479871675608582260581433386579286302477336199984087082550505;
    
    uint256 constant IC22x = 10395245352286791689180078192793973407773474250720989913360443552945366690445;
    uint256 constant IC22y = 21525747149242755352826522510266760369233952312243757636212861381421720874092;
    
    uint256 constant IC23x = 2923409587787492516403353804626639779689726799780546168587575281191144155968;
    uint256 constant IC23y = 18539106391037923561885039194262058980799641312731026363979338003911499668903;
    
    uint256 constant IC24x = 14444678570946335069542597344360967235397684826547873446226558331325980173169;
    uint256 constant IC24y = 3778989712208498376683972988843801211813853470311225062285191580557884601686;
    
    uint256 constant IC25x = 3705810764549750388419427527046581884489782049865235684570577609391995435688;
    uint256 constant IC25y = 12573968489245553733851216830670166339180416519294742896836362134380744049118;
    
    uint256 constant IC26x = 16682082326906208874419835024820984022443368211228071708793096382463793811264;
    uint256 constant IC26y = 3765240510148372101557669938548716359907799365143684161103177506961140719320;
    
    uint256 constant IC27x = 2446864319199173707935312881340143909355810209170747755946859409672090345702;
    uint256 constant IC27y = 1728424964447128431809251309628804461930411406110442115035339971503493776821;
    
    uint256 constant IC28x = 5333463620948056407654376971809978240305633782252384798522176601516316623812;
    uint256 constant IC28y = 17847029896104956424124684102756320946273627854690273925667278522171332466802;
    
    uint256 constant IC29x = 6565257409659114269007476316358415554161358230497422469993705838248080038139;
    uint256 constant IC29y = 13777574552686266777572167381758298855756833239944843029697839305794747204350;
    
    uint256 constant IC30x = 20085592000317268161069358813869667281369620294330270693538223567815840020306;
    uint256 constant IC30y = 6987562038833484364340137962525933763229538752701080468678736340045513199020;
    
    uint256 constant IC31x = 6750239780643052317128260096653534519227231814581674943421088726137342711201;
    uint256 constant IC31y = 20679195908068944941346409562013993294376762443352643438606742508956522980867;
    
    uint256 constant IC32x = 10151518672582764171748761417736475111173519737865524312574904185714718002791;
    uint256 constant IC32y = 13776723538511744778019917733721603426343332852384884514371628479009784381988;
    
    uint256 constant IC33x = 19027263381518013796974083917666824755575008186544784639400137268138475783530;
    uint256 constant IC33y = 15076168570811828817138586360600454423247040590944826421552996832779320644836;
    
    uint256 constant IC34x = 16736902658787377629836799071932082139914445001272067172483970633327723203409;
    uint256 constant IC34y = 11761329284069363595330720676521422724775057342486636588677253082259868669096;
    
    uint256 constant IC35x = 9709432617349968088889767203244005457217053712051374424604335822335595469411;
    uint256 constant IC35y = 6794255211089111060034405023092638529125301762629632248866038798761980700697;
    
    uint256 constant IC36x = 10091978182316271241883493178477953002332471160366139018578372258953460859070;
    uint256 constant IC36y = 9248206531478410736174430023324862028949200379703494581058940203644933629242;
    
    uint256 constant IC37x = 20178706575893194010997511148792631339798166998925551612702748719231410285232;
    uint256 constant IC37y = 14870282093153451768309913443200981129519566133057129742396751772217297214946;
    
    uint256 constant IC38x = 13600377217975439416850437992344965975875108387149534711695684831134566471002;
    uint256 constant IC38y = 15598108579128875028377824503349013917667612047015984593304762112221073297211;
    
    uint256 constant IC39x = 20635099347528877179803792788326539559450039903918351075211661408984349402154;
    uint256 constant IC39y = 15206504885853673264522566838729492989302104615759410795126542598047857609850;
    
    uint256 constant IC40x = 10732453643689486238004569934935071484098249589542102000563664410593017943618;
    uint256 constant IC40y = 6869858818878144373958301196200941339770858750901916705342653957600369398857;
    
    uint256 constant IC41x = 3439334050567572154977712084095759944281183323418738759745352773681673310073;
    uint256 constant IC41y = 3892813833576869467519538635931600944001361907320851932829574450112865084020;
    
    uint256 constant IC42x = 6462097827054270451075028261756852981746148662671924376705181685408723435786;
    uint256 constant IC42y = 15759050014297348421078170001122115921652724843839475724663135091032619352601;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[42] calldata _pubSignals) public returns (bool) {
        assembly {
            function checkField(v) {
                if iszero(lt(v, r)) {
                    mstore(0, 0)
                    return(0, 0x20)
                }
            }
            
            // G1 function to multiply a G1 value(x,y) to value in an address
            function g1_mulAccC(pR, x, y, s) {
                let success
                let mIn := mload(0x40)
                mstore(mIn, x)
                mstore(add(mIn, 32), y)
                mstore(add(mIn, 64), s)

                success := staticcall(sub(gas(), 2000), 7, mIn, 96, mIn, 64)

                if iszero(success) {
                    mstore(0, 0)
                    return(0, 0x20)
                }

                mstore(add(mIn, 64), mload(pR))
                mstore(add(mIn, 96), mload(add(pR, 32)))

                success := staticcall(sub(gas(), 2000), 6, mIn, 128, pR, 64)

                if iszero(success) {
                    mstore(0, 0)
                    return(0, 0x20)
                }
            }

            function checkPairing(pA, pB, pC, pubSignals, pMem) -> isOk {
                let _pPairing := add(pMem, pPairing)
                let _pVk := add(pMem, pVk)

                mstore(_pVk, IC0x)
                mstore(add(_pVk, 32), IC0y)

                // Compute the linear combination vk_x
                
                g1_mulAccC(_pVk, IC1x, IC1y, calldataload(add(pubSignals, 0)))
                
                g1_mulAccC(_pVk, IC2x, IC2y, calldataload(add(pubSignals, 32)))
                
                g1_mulAccC(_pVk, IC3x, IC3y, calldataload(add(pubSignals, 64)))
                
                g1_mulAccC(_pVk, IC4x, IC4y, calldataload(add(pubSignals, 96)))
                
                g1_mulAccC(_pVk, IC5x, IC5y, calldataload(add(pubSignals, 128)))
                
                g1_mulAccC(_pVk, IC6x, IC6y, calldataload(add(pubSignals, 160)))
                
                g1_mulAccC(_pVk, IC7x, IC7y, calldataload(add(pubSignals, 192)))
                
                g1_mulAccC(_pVk, IC8x, IC8y, calldataload(add(pubSignals, 224)))
                
                g1_mulAccC(_pVk, IC9x, IC9y, calldataload(add(pubSignals, 256)))
                
                g1_mulAccC(_pVk, IC10x, IC10y, calldataload(add(pubSignals, 288)))
                
                g1_mulAccC(_pVk, IC11x, IC11y, calldataload(add(pubSignals, 320)))
                
                g1_mulAccC(_pVk, IC12x, IC12y, calldataload(add(pubSignals, 352)))
                
                g1_mulAccC(_pVk, IC13x, IC13y, calldataload(add(pubSignals, 384)))
                
                g1_mulAccC(_pVk, IC14x, IC14y, calldataload(add(pubSignals, 416)))
                
                g1_mulAccC(_pVk, IC15x, IC15y, calldataload(add(pubSignals, 448)))
                
                g1_mulAccC(_pVk, IC16x, IC16y, calldataload(add(pubSignals, 480)))
                
                g1_mulAccC(_pVk, IC17x, IC17y, calldataload(add(pubSignals, 512)))
                
                g1_mulAccC(_pVk, IC18x, IC18y, calldataload(add(pubSignals, 544)))
                
                g1_mulAccC(_pVk, IC19x, IC19y, calldataload(add(pubSignals, 576)))
                
                g1_mulAccC(_pVk, IC20x, IC20y, calldataload(add(pubSignals, 608)))
                
                g1_mulAccC(_pVk, IC21x, IC21y, calldataload(add(pubSignals, 640)))
                
                g1_mulAccC(_pVk, IC22x, IC22y, calldataload(add(pubSignals, 672)))
                
                g1_mulAccC(_pVk, IC23x, IC23y, calldataload(add(pubSignals, 704)))
                
                g1_mulAccC(_pVk, IC24x, IC24y, calldataload(add(pubSignals, 736)))
                
                g1_mulAccC(_pVk, IC25x, IC25y, calldataload(add(pubSignals, 768)))
                
                g1_mulAccC(_pVk, IC26x, IC26y, calldataload(add(pubSignals, 800)))
                
                g1_mulAccC(_pVk, IC27x, IC27y, calldataload(add(pubSignals, 832)))
                
                g1_mulAccC(_pVk, IC28x, IC28y, calldataload(add(pubSignals, 864)))
                
                g1_mulAccC(_pVk, IC29x, IC29y, calldataload(add(pubSignals, 896)))
                
                g1_mulAccC(_pVk, IC30x, IC30y, calldataload(add(pubSignals, 928)))
                
                g1_mulAccC(_pVk, IC31x, IC31y, calldataload(add(pubSignals, 960)))
                
                g1_mulAccC(_pVk, IC32x, IC32y, calldataload(add(pubSignals, 992)))
                
                g1_mulAccC(_pVk, IC33x, IC33y, calldataload(add(pubSignals, 1024)))
                
                g1_mulAccC(_pVk, IC34x, IC34y, calldataload(add(pubSignals, 1056)))
                
                g1_mulAccC(_pVk, IC35x, IC35y, calldataload(add(pubSignals, 1088)))
                
                g1_mulAccC(_pVk, IC36x, IC36y, calldataload(add(pubSignals, 1120)))
                
                g1_mulAccC(_pVk, IC37x, IC37y, calldataload(add(pubSignals, 1152)))
                
                g1_mulAccC(_pVk, IC38x, IC38y, calldataload(add(pubSignals, 1184)))
                
                g1_mulAccC(_pVk, IC39x, IC39y, calldataload(add(pubSignals, 1216)))
                
                g1_mulAccC(_pVk, IC40x, IC40y, calldataload(add(pubSignals, 1248)))
                
                g1_mulAccC(_pVk, IC41x, IC41y, calldataload(add(pubSignals, 1280)))
                
                g1_mulAccC(_pVk, IC42x, IC42y, calldataload(add(pubSignals, 1312)))
                

                // -A
                mstore(_pPairing, calldataload(pA))
                mstore(add(_pPairing, 32), mod(sub(q, calldataload(add(pA, 32))), q))

                // B
                mstore(add(_pPairing, 64), calldataload(pB))
                mstore(add(_pPairing, 96), calldataload(add(pB, 32)))
                mstore(add(_pPairing, 128), calldataload(add(pB, 64)))
                mstore(add(_pPairing, 160), calldataload(add(pB, 96)))

                // alpha1
                mstore(add(_pPairing, 192), alphax)
                mstore(add(_pPairing, 224), alphay)

                // beta2
                mstore(add(_pPairing, 256), betax1)
                mstore(add(_pPairing, 288), betax2)
                mstore(add(_pPairing, 320), betay1)
                mstore(add(_pPairing, 352), betay2)

                // vk_x
                mstore(add(_pPairing, 384), mload(add(pMem, pVk)))
                mstore(add(_pPairing, 416), mload(add(pMem, add(pVk, 32))))


                // gamma2
                mstore(add(_pPairing, 448), gammax1)
                mstore(add(_pPairing, 480), gammax2)
                mstore(add(_pPairing, 512), gammay1)
                mstore(add(_pPairing, 544), gammay2)

                // C
                mstore(add(_pPairing, 576), calldataload(pC))
                mstore(add(_pPairing, 608), calldataload(add(pC, 32)))

                // delta2
                mstore(add(_pPairing, 640), deltax1)
                mstore(add(_pPairing, 672), deltax2)
                mstore(add(_pPairing, 704), deltay1)
                mstore(add(_pPairing, 736), deltay2)


                let success := staticcall(sub(gas(), 2000), 8, _pPairing, 768, _pPairing, 0x20)

                isOk := and(success, mload(_pPairing))
            }

            let pMem := mload(0x40)
            mstore(0x40, add(pMem, pLastMem))

            // Validate that all evaluations ∈ F
            
            checkField(calldataload(add(_pubSignals, 0)))
            
            checkField(calldataload(add(_pubSignals, 32)))
            
            checkField(calldataload(add(_pubSignals, 64)))
            
            checkField(calldataload(add(_pubSignals, 96)))
            
            checkField(calldataload(add(_pubSignals, 128)))
            
            checkField(calldataload(add(_pubSignals, 160)))
            
            checkField(calldataload(add(_pubSignals, 192)))
            
            checkField(calldataload(add(_pubSignals, 224)))
            
            checkField(calldataload(add(_pubSignals, 256)))
            
            checkField(calldataload(add(_pubSignals, 288)))
            
            checkField(calldataload(add(_pubSignals, 320)))
            
            checkField(calldataload(add(_pubSignals, 352)))
            
            checkField(calldataload(add(_pubSignals, 384)))
            
            checkField(calldataload(add(_pubSignals, 416)))
            
            checkField(calldataload(add(_pubSignals, 448)))
            
            checkField(calldataload(add(_pubSignals, 480)))
            
            checkField(calldataload(add(_pubSignals, 512)))
            
            checkField(calldataload(add(_pubSignals, 544)))
            
            checkField(calldataload(add(_pubSignals, 576)))
            
            checkField(calldataload(add(_pubSignals, 608)))
            
            checkField(calldataload(add(_pubSignals, 640)))
            
            checkField(calldataload(add(_pubSignals, 672)))
            
            checkField(calldataload(add(_pubSignals, 704)))
            
            checkField(calldataload(add(_pubSignals, 736)))
            
            checkField(calldataload(add(_pubSignals, 768)))
            
            checkField(calldataload(add(_pubSignals, 800)))
            
            checkField(calldataload(add(_pubSignals, 832)))
            
            checkField(calldataload(add(_pubSignals, 864)))
            
            checkField(calldataload(add(_pubSignals, 896)))
            
            checkField(calldataload(add(_pubSignals, 928)))
            
            checkField(calldataload(add(_pubSignals, 960)))
            
            checkField(calldataload(add(_pubSignals, 992)))
            
            checkField(calldataload(add(_pubSignals, 1024)))
            
            checkField(calldataload(add(_pubSignals, 1056)))
            
            checkField(calldataload(add(_pubSignals, 1088)))
            
            checkField(calldataload(add(_pubSignals, 1120)))
            
            checkField(calldataload(add(_pubSignals, 1152)))
            
            checkField(calldataload(add(_pubSignals, 1184)))
            
            checkField(calldataload(add(_pubSignals, 1216)))
            
            checkField(calldataload(add(_pubSignals, 1248)))
            
            checkField(calldataload(add(_pubSignals, 1280)))
            
            checkField(calldataload(add(_pubSignals, 1312)))
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
