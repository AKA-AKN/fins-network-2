/*
 * SPDX-License-Identifier: Apache-2.0
 */

'use strict';

const { ChaincodeStub, ClientIdentity } = require('fabric-shim');
const { DiseaseCodeContract } = require('..');
const winston = require('winston');

const chai = require('chai');
const chaiAsPromised = require('chai-as-promised');
const sinon = require('sinon');
const sinonChai = require('sinon-chai');

chai.should();
chai.use(chaiAsPromised);
chai.use(sinonChai);

class TestContext {

    constructor() {
        this.stub = sinon.createStubInstance(ChaincodeStub);
        this.clientIdentity = sinon.createStubInstance(ClientIdentity);
        this.logger = {
            getLogger: sinon.stub().returns(sinon.createStubInstance(winston.createLogger().constructor)),
            setLevel: sinon.stub(),
        };
    }

}

describe('DiseaseCodeContract', () => {

    let contract;
    let ctx;

    beforeEach(() => {
        contract = new DiseaseCodeContract();
        ctx = new TestContext();
        ctx.stub.getState.withArgs('1001').resolves(Buffer.from('{"value":"disease code 1001 value"}'));
        ctx.stub.getState.withArgs('1002').resolves(Buffer.from('{"value":"disease code 1002 value"}'));
    });

    describe('#diseaseCodeExists', () => {

        it('should return true for a disease code', async () => {
            await contract.diseaseCodeExists(ctx, '1001').should.eventually.be.true;
        });

        it('should return false for a disease code that does not exist', async () => {
            await contract.diseaseCodeExists(ctx, '1003').should.eventually.be.false;
        });

    });

    describe('#createDiseaseCode', () => {

        it('should create a disease code', async () => {
            await contract.createDiseaseCode(ctx, '1003', 'disease code 1003 value');
            ctx.stub.putState.should.have.been.calledOnceWithExactly('1003', Buffer.from('{"value":"disease code 1003 value"}'));
        });

        it('should throw an error for a disease code that already exists', async () => {
            await contract.createDiseaseCode(ctx, '1001', 'myvalue').should.be.rejectedWith(/The disease code 1001 already exists/);
        });

    });

    describe('#readDiseaseCode', () => {

        it('should return a disease code', async () => {
            await contract.readDiseaseCode(ctx, '1001').should.eventually.deep.equal({ value: 'disease code 1001 value' });
        });

        it('should throw an error for a disease code that does not exist', async () => {
            await contract.readDiseaseCode(ctx, '1003').should.be.rejectedWith(/The disease code 1003 does not exist/);
        });

    });

    describe('#updateDiseaseCode', () => {

        it('should update a disease code', async () => {
            await contract.updateDiseaseCode(ctx, '1001', 'disease code 1001 new value');
            ctx.stub.putState.should.have.been.calledOnceWithExactly('1001', Buffer.from('{"value":"disease code 1001 new value"}'));
        });

        it('should throw an error for a disease code that does not exist', async () => {
            await contract.updateDiseaseCode(ctx, '1003', 'disease code 1003 new value').should.be.rejectedWith(/The disease code 1003 does not exist/);
        });

    });

    describe('#deleteDiseaseCode', () => {

        it('should delete a disease code', async () => {
            await contract.deleteDiseaseCode(ctx, '1001');
            ctx.stub.deleteState.should.have.been.calledOnceWithExactly('1001');
        });

        it('should throw an error for a disease code that does not exist', async () => {
            await contract.deleteDiseaseCode(ctx, '1003').should.be.rejectedWith(/The disease code 1003 does not exist/);
        });

    });

});
