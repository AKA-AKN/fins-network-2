/*
 * SPDX-License-Identifier: Apache-2.0
 */

'use strict';

const { ChaincodeStub, ClientIdentity } = require('fabric-shim');
const { DiseaseDataContract } = require('..');
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

describe('DiseaseDataContract', () => {

    let contract;
    let ctx;

    beforeEach(() => {
        contract = new DiseaseDataContract();
        ctx = new TestContext();
        ctx.stub.getState.withArgs('1001').resolves(Buffer.from('{"value":"disease data 1001 value"}'));
        ctx.stub.getState.withArgs('1002').resolves(Buffer.from('{"value":"disease data 1002 value"}'));
    });

    describe('#diseaseDataExists', () => {

        it('should return true for a disease data', async () => {
            await contract.diseaseDataExists(ctx, '1001').should.eventually.be.true;
        });

        it('should return false for a disease data that does not exist', async () => {
            await contract.diseaseDataExists(ctx, '1003').should.eventually.be.false;
        });

    });

    describe('#createDiseaseData', () => {

        it('should create a disease data', async () => {
            await contract.createDiseaseData(ctx, '1003', 'disease data 1003 value');
            ctx.stub.putState.should.have.been.calledOnceWithExactly('1003', Buffer.from('{"value":"disease data 1003 value"}'));
        });

        it('should throw an error for a disease data that already exists', async () => {
            await contract.createDiseaseData(ctx, '1001', 'myvalue').should.be.rejectedWith(/The disease data 1001 already exists/);
        });

    });

    describe('#readDiseaseData', () => {

        it('should return a disease data', async () => {
            await contract.readDiseaseData(ctx, '1001').should.eventually.deep.equal({ value: 'disease data 1001 value' });
        });

        it('should throw an error for a disease data that does not exist', async () => {
            await contract.readDiseaseData(ctx, '1003').should.be.rejectedWith(/The disease data 1003 does not exist/);
        });

    });

    describe('#updateDiseaseData', () => {

        it('should update a disease data', async () => {
            await contract.updateDiseaseData(ctx, '1001', 'disease data 1001 new value');
            ctx.stub.putState.should.have.been.calledOnceWithExactly('1001', Buffer.from('{"value":"disease data 1001 new value"}'));
        });

        it('should throw an error for a disease data that does not exist', async () => {
            await contract.updateDiseaseData(ctx, '1003', 'disease data 1003 new value').should.be.rejectedWith(/The disease data 1003 does not exist/);
        });

    });

    describe('#deleteDiseaseData', () => {

        it('should delete a disease data', async () => {
            await contract.deleteDiseaseData(ctx, '1001');
            ctx.stub.deleteState.should.have.been.calledOnceWithExactly('1001');
        });

        it('should throw an error for a disease data that does not exist', async () => {
            await contract.deleteDiseaseData(ctx, '1003').should.be.rejectedWith(/The disease data 1003 does not exist/);
        });

    });

});
